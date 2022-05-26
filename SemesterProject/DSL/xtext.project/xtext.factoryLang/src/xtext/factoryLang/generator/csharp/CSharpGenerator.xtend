package xtext.factoryLang.generator.csharp

import xtext.factoryLang.factoryLang.Model
import org.eclipse.xtext.generator.IFileSystemAccess2

class CSharpGenerator {

	def static generate(IFileSystemAccess2 fsa, Model model) {
		SrcProjectGenerator.generate(fsa, model)
		//TestProjectGenerator.generate(fsa, model)
	}
}
