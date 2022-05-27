package xtext.factoryLang.generator.csharp

import org.eclipse.xtext.generator.IFileSystemAccess2
import xtext.factoryLang.factoryLang.Model

class SolutionGenerator {
	
	def static generate(IFileSystemAccess2 fsa, Model model) {
		fsa.generateFile('''«model.name»/«model.name».sln''', '''
		Microsoft Visual Studio Solution File, Format Version 12.00
		# Visual Studio Version 16
		VisualStudioVersion = 16.0.30114.105
		MinimumVisualStudioVersion = 10.0.40219.1
		Project("{2150E333-8FDC-42A3-9474-1A3956D46DE8}") = "src", "src", "{212ACE7A-DAA6-4CD1-8EEB-E454DB67F5DB}"
		EndProject
		Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "«model.name»", "src\«model.name»\«model.name».csproj", "{12C0F046-5CF7-468F-B75D-4A5D27C7831F}"
		EndProject
		Project("{2150E333-8FDC-42A3-9474-1A3956D46DE8}") = "test", "test", "{98C69385-2F61-4EEF-9888-83C3DF23DAF7}"
		EndProject
		Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "«model.name».Tests", "test\«model.name».Tests\«model.name».Tests.csproj", "{609258AC-0FF7-477C-AAAF-7365AEDD8C32}"
		EndProject
		Global
			GlobalSection(SolutionConfigurationPlatforms) = preSolution
				Debug|Any CPU = Debug|Any CPU
				Release|Any CPU = Release|Any CPU
			EndGlobalSection
			GlobalSection(SolutionProperties) = preSolution
				HideSolutionNode = FALSE
			EndGlobalSection
			GlobalSection(ProjectConfigurationPlatforms) = postSolution
				{12C0F046-5CF7-468F-B75D-4A5D27C7831F}.Debug|Any CPU.ActiveCfg = Debug|Any CPU
				{12C0F046-5CF7-468F-B75D-4A5D27C7831F}.Debug|Any CPU.Build.0 = Debug|Any CPU
				{12C0F046-5CF7-468F-B75D-4A5D27C7831F}.Release|Any CPU.ActiveCfg = Release|Any CPU
				{12C0F046-5CF7-468F-B75D-4A5D27C7831F}.Release|Any CPU.Build.0 = Release|Any CPU
				{609258AC-0FF7-477C-AAAF-7365AEDD8C32}.Debug|Any CPU.ActiveCfg = Debug|Any CPU
				{609258AC-0FF7-477C-AAAF-7365AEDD8C32}.Debug|Any CPU.Build.0 = Debug|Any CPU
				{609258AC-0FF7-477C-AAAF-7365AEDD8C32}.Release|Any CPU.ActiveCfg = Release|Any CPU
				{609258AC-0FF7-477C-AAAF-7365AEDD8C32}.Release|Any CPU.Build.0 = Release|Any CPU
			EndGlobalSection
			GlobalSection(NestedProjects) = preSolution
				{12C0F046-5CF7-468F-B75D-4A5D27C7831F} = {212ACE7A-DAA6-4CD1-8EEB-E454DB67F5DB}
				{609258AC-0FF7-477C-AAAF-7365AEDD8C32} = {98C69385-2F61-4EEF-9888-83C3DF23DAF7}
			EndGlobalSection
		EndGlobal
		''')
	}
	
}