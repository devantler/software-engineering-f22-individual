package xtext.factoryLang.generator.csharp

import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.generator.IFileSystemAccess2
import xtext.factoryLang.factoryLang.Camera
import xtext.factoryLang.factoryLang.ConnectionUnitTest
import xtext.factoryLang.factoryLang.Crane
import xtext.factoryLang.factoryLang.DeviceInitializationUnitTest
import xtext.factoryLang.factoryLang.Disk
import xtext.factoryLang.factoryLang.HealthCheckUnitTest
import xtext.factoryLang.factoryLang.Model
import xtext.factoryLang.factoryLang.RunWithoutFailureUnitTest
import xtext.factoryLang.factoryLang.STATUS
import xtext.factoryLang.factoryLang.UnitTest

class UnitTestGenerator {

	def static generate(IFileSystemAccess2 fsa, Model model) {
		fsa.generateFile('''«model.name»/test/«model.name».Tests/Usings.cs''', '''global using Xunit;''')
		fsa.generateFile('''«model.name»/test/«model.name».Tests/UnitTests.cs''', '''
			using System.Net.Sockets;
			using Mqtt;
			
			namespace «model.name».Tests;
			
			public class UnitTests
			{
				«generateUnitTests(model.unitTests)»
			}
		''')
	}

	def static String generateUnitTests(EList<UnitTest> unitTests) '''
		«FOR unitTest : unitTests»
			«generateUnitTest(unitTest)»
		«ENDFOR»
	'''

	def static String generateUnitTest(UnitTest test) {
		switch test {
			HealthCheckUnitTest: '''
				[Fact]
				public void «test.service.name.toFirstUpper»«test.class.simpleName.replace("Impl", "")»()
				{
					try {
						using var client = new TcpClient("«test.service.address.replace('^', '')»", «test.service.port»);
						«IF test.status == STATUS.UP»
							Assert.True(client.Connected, "«test.service.name.toFirstUpper» service is not available");
						«ELSE»
							Assert.True(!client.Connected, "«test.service.name.toFirstUpper» service is available");
						«ENDIF»
					} catch (Exception) {
						Assert.False(true);
					}
				}
				
			'''
			ConnectionUnitTest: '''
				«IF test.service.name == "mqtt"»
					[Fact]
					public async Task «test.service.name.toFirstUpper»«test.class.simpleName.replace("Impl", "")»()
					{
						var mqttService = new MqttService("«test.service.address.replace('^', '')»", «test.service.port»);
						int retryCount = 0;
						bool connected = mqttService._mqttClient.IsConnected;
						while(retryCount < 3) {
							if(connected) {
								break;
							}
							await Task.Delay(5000);
							retryCount++;
						}
						Assert.True(mqttService._mqttClient.IsConnected, "«test.service.name.toFirstUpper» service is not available");
					}
					
				«ENDIF»
			'''
			DeviceInitializationUnitTest: '''
				[Fact]
				public void «test.class.simpleName.replace("Impl", "")»()
				{
					Program program = new();
					program.Setup();
					«IF getCranes(test).size > 0»
						Assert.True(program.cranes.Count == «getCranes(test).size»);
						Assert.Collection(program.cranes,
						«FOR crane : getCranes(test)»
							«"	"»«crane.name» => Assert.Equal("«crane.name»", «crane.name».Key)
						«ENDFOR»
						);
						
					«ENDIF»
					«IF getDisks(test).size > 0»
						Assert.True(program.disks.Count == «getDisks(test).size»);
						Assert.Collection(program.disks,
						«FOR disk : getDisks(test)»
							«"	"»«disk.name» => Assert.Equal("«disk.name»", «disk.name».Key)
						«ENDFOR»
						);
						
					«ENDIF»
					«IF getCameras(test).size > 0»
						Assert.True(program.disks.Count == «getCameras(test).size»);
						Assert.Collection(program.cameras,
						«FOR camera : getCameras(test)»
							«"	"»«camera.name» => Assert.Equal("«camera.name»", «camera.name».Key)
						«ENDFOR»
						);
					«ENDIF»
				}
				
			'''
			RunWithoutFailureUnitTest: '''
				[Fact]
				public void «test.class.simpleName.replace("Impl", "")»()
				{
					Program program = new();
					program.Setup();
					Assert.True(program.Run().IsCompletedSuccessfully);
				}
			'''
		}
	}

	protected def static Iterable<Crane> getCranes(DeviceInitializationUnitTest test) {
		test.devices.filter[it instanceof Crane].map[it as Crane].toList
	}

	protected def static Iterable<Disk> getDisks(DeviceInitializationUnitTest test) {
		test.devices.filter[it instanceof Disk].map[it as Disk].toList
	}

	protected def static Iterable<Camera> getCameras(DeviceInitializationUnitTest test) {
		test.devices.filter[it instanceof Camera].map[it as Camera].toList
	}
}
