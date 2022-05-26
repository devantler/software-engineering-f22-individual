package xtext.factoryLang.generator.csharp

import xtext.factoryLang.factoryLang.Model
import org.eclipse.xtext.generator.IFileSystemAccess2
import xtext.factoryLang.factoryLang.Crane
import xtext.factoryLang.factoryLang.Disk
import xtext.factoryLang.factoryLang.Camera

class SrcProjectGenerator {
	
	def static generate(IFileSystemAccess2 fsa, Model model) {
		val devices = model.configuration.devices.map[it]
		val statements = model.statements
		ProgramGenerator.generate(fsa, model.name, devices, statements)
		CsprojGenerator.generate(fsa, model.name)
		MqttGenerator.generate(fsa, model.name)
		EntityGenerator.generate(
			fsa,
			model.name,
			devices.filter[it instanceof Crane].size > 0,
			devices.filter[it instanceof Disk].size > 0,
			devices.filter[it instanceof Camera].size > 0
		)
	}
	
}