using System;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using CameraColorScanner.Adapters;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MQTTnet.Client;
using MQTTnet;
using MQTTnet.Protocol;

namespace CameraColorScanner.Services
{

    public class MqttService : IHostedService
    {
        private MqttClient _mqttClient;
        private readonly IColorScannerAdapter _colorScanner;


        public MqttService(IColorScannerAdapter colorScannerAdapter)
        {
            try
            {
                _colorScanner = colorScannerAdapter;
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error starting MQTT service: {e.Message}\n{e.StackTrace}");
            }
        }

        public async Task StartAsync(CancellationToken cancellationToken)
        {
            try
            {
                Console.WriteLine("Starting MQTT service...");
                _mqttClient = new MqttFactory().CreateMqttClient();
                var mqttOptionsBuilder = new MqttClientOptionsBuilder()
                    .WithClientId(Configuration.Mqtt.ClientId)
                    .WithTcpServer(Configuration.Mqtt.Hostname, Configuration.Mqtt.Port);
                if (Configuration.Mqtt.Username != null
                    && Configuration.Mqtt.Password != null)
                {
                    Console.WriteLine("With credentials");
                    mqttOptionsBuilder.WithCredentials(Configuration.Mqtt.Username, Configuration.Mqtt.Password);
                }

                if (Configuration.Mqtt.UseSsl)
                {
                    Console.WriteLine("With tls");
                    mqttOptionsBuilder.WithTls();
                }

                Console.WriteLine("Trying to connect...");
                await _mqttClient.ConnectAsync(mqttOptionsBuilder.Build(), cancellationToken);

                while (!_mqttClient.IsConnected)
                {
                    await Task.Delay(50);
                    Console.Write(".");
                }

                Console.WriteLine("Connected!");

                await _mqttClient.SubscribeAsync(Configuration.Mqtt.CommandTopic, MqttQualityOfServiceLevel.ExactlyOnce,
                    cancellationToken);
                _mqttClient.ApplicationMessageReceivedAsync += MqttCallback;
            }
            catch (Exception e)
            {
                Console.WriteLine("Error in mqttservice start: " + e.Message + "\n" + e.StackTrace);
            }
        }

        private async Task MqttCallback(MqttApplicationMessageReceivedEventArgs args)
        {
            try
            {
                var topic = args.ApplicationMessage.Topic;
                var message = Encoding.UTF8.GetString(args.ApplicationMessage.Payload);
                Console.WriteLine($"Message received: {message}");
                Console.WriteLine("On topic: " + topic);

                if (topic == Configuration.Mqtt.CommandTopic && message == "GetColor")
                {
                    if (Configuration.Mqtt.PrintDebug)
                    {
                        Console.WriteLine("Got message!");
                    }
                    await SendMessage(
                            Configuration.Mqtt.ScanningTopic,
                            "true",
                            true);
                    var scannedColor = await _colorScanner.GetColor();

                    var resultTopic = Configuration.Mqtt.ResultTopic;
                    if (resultTopic == null)
                    {
                        await SendMessage(
                            Configuration.Mqtt.LogTopic + "/error",
                            $"Result topic not defined.",
                            true);
                    }
                    else
                    {
                        await SendMessage(
                            Configuration.Mqtt.ResultTopic, //The exclamation-point suppresses null warning
                            scannedColor.ToString(),
                            false);
                    }
                    await SendMessage(
                            Configuration.Mqtt.ScanningTopic,
                            "false",
                            true);
                }
                else if (topic == Configuration.Mqtt.CommandTopic && message.StartsWith("SetLoggingLevel")){
                    var messageArray = message.Split(' ');
                    if (messageArray.length != 2)
                    {
                        if (Configuration.Mqtt.PrintDebug)
                        {
                            Console.WriteLine($"Invalid SetLogginLevel: {message}");
                        }
                        await SendMessage(
                        Configuration.Mqtt.LogTopic + "/error",
                        $"Invalid SetLogginLevel: {message}",
                        true);
                        return;
                    }
                    var level = messageArray[1];
                    var isEnumParsed = Enum.TryParse("0", true, out LoggingHelper.LoggingLevel loggingLevel);
                    if (isEnumParsed)
                    {
                        if (Configuration.Mqtt.PrintDebug)
                        {
                            Console.WriteLine($"Setting logging level to {loggingLevel}");
                        }
                        LoggingHelper.loggingLevel = loggingLevel;
                    } else
                    {
                        if (Configuration.Mqtt.PrintDebug)
                        {
                            Console.WriteLine($"Couldn't parse logging level {level}");
                        }
                        await SendMessage(
                        Configuration.Mqtt.LogTopic + "/error",
                        $"Couldn't parse logging level {level}",
                        true);
                    }
                    
                }
                else
                {
                    if (Configuration.Mqtt.PrintDebug)
                    {
                        Console.WriteLine($"Unknown topic: {topic} or command: {message}");
                    }

                    await SendMessage(
                        Configuration.Mqtt.LogTopic + "/error",
                        $"Unknown topic: {topic} or command: {message}",
                        true);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error getting color: {e.Message}\n{e.StackTrace}");
            }
        }

        public async Task SendMessage(string topic, string payload, bool retain = false)
        {
            var topicArray = topic.Split('/');
            if (topicArray[topicArray.length - 1] == "")
            {
                return;
            }
            {
                Console.WriteLine("Topic is too long!");
                return;
            }
            await SendMessage(topic, Encoding.UTF8.GetBytes(payload), retain);
        }

        public async Task SendMessage(string topic, byte[] payload, bool retain = false)
        {
            var mqttMessage = new MqttApplicationMessageBuilder()
                .WithTopic(topic)
                .WithRetainFlag(retain)
                .WithPayload(payload)
                .WithQualityOfServiceLevel(MqttQualityOfServiceLevel.ExactlyOnce);

            await _mqttClient.PublishAsync(mqttMessage.Build(), CancellationToken.None);
        }

        public async Task StopAsync(CancellationToken cancellationToken)
        {
            await _mqttClient.DisconnectAsync();
        }
    }
}