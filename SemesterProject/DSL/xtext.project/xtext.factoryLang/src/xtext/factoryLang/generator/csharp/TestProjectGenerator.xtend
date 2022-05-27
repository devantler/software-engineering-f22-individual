package xtext.factoryLang.generator.csharp

import xtext.factoryLang.factoryLang.Model
import org.eclipse.xtext.generator.IFileSystemAccess2
import xtext.factoryLang.factoryLang.Crane
import xtext.factoryLang.factoryLang.Disk
import xtext.factoryLang.factoryLang.Camera

class TestProjectGenerator {

	def static generate(IFileSystemAccess2 fsa, Model model) {
		CsprojGenerator.generate(fsa, model.name, ProjectType.TestProject)
		UnitTestGenerator.generate(fsa, model)
	}
}
