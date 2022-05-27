using System.Net.Sockets;
using Mqtt;

namespace OrchestratorService.Tests;

public class UnitTests
{
	[Fact]
	public void MqttHealthCheckUnitTest()
	{
		try {
			using var client = new TcpClient("test.mosquitto.org", 1883);
			Assert.True(client.Connected, "Mqtt service is not available");
		} catch (Exception) {
			Assert.False(true);
		}
	}
	
	[Fact]
	public async Task MqttConnectionUnitTest()
	{
		var mqttService = new MqttService("test.mosquitto.org", 1883);
		int retryCount = 0;
		bool connected = mqttService._mqttClient.IsConnected;
		while(retryCount < 3) {
			if(connected) {
				break;
			}
			await Task.Delay(5000);
			retryCount++;
		}
		Assert.True(mqttService._mqttClient.IsConnected, "Mqtt service is not available");
	}
	
	[Fact]
	public void InfluxdbHealthCheckUnitTest()
	{
		try {
			using var client = new TcpClient("influxdb.devantler.com", 8086);
			Assert.True(!client.Connected, "Influxdb service is available");
		} catch (Exception) {
			Assert.False(true);
		}
	}
	
	[Fact]
	public void DeviceInitializationUnitTest()
	{
		Program program = new();
		program.Setup();
		Assert.True(program.cranes.Count == 1);
		Assert.Collection(program.cranes,
			crane1 => Assert.Equal("crane1", crane1.Key)
		);
		
		Assert.True(program.disks.Count == 1);
		Assert.Collection(program.disks,
			disk1 => Assert.Equal("disk1", disk1.Key)
		);
		
		Assert.True(program.disks.Count == 1);
		Assert.Collection(program.cameras,
			camera1 => Assert.Equal("camera1", camera1.Key)
		);
	}
	
	[Fact]
	public void RunWithoutFailureUnitTest()
	{
		Program program = new();
		program.Setup();
		Assert.True(program.Run().IsCompletedSuccessfully);
	}
}
