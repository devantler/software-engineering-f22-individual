package xtext.factoryLang.generator.csharp

import org.eclipse.xtext.generator.IFileSystemAccess2

class CsprojGenerator {

	def static generate(IFileSystemAccess2 fsa, String name, ProjectType type) {
		switch (type) {
			case SrcProject: {
				generateSrcProjectCsproj(fsa, name)
			}
			case TestProject: {
				generateTestProjectCsproj(fsa, name)
			}
		}

	}
	
	protected def static void generateTestProjectCsproj(IFileSystemAccess2 fsa, String name) {
		fsa.generateFile('''«name»/test/«name».Tests/«name».Tests.csproj''', '''
			<Project Sdk="Microsoft.NET.Sdk">
			
			  <PropertyGroup>
			    <TargetFramework>net6.0</TargetFramework>
			    <ImplicitUsings>enable</ImplicitUsings>
			    <Nullable>enable</Nullable>
			
			    <IsPackable>false</IsPackable>
			  </PropertyGroup>
			
			  <ItemGroup>
			    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.2.0" />
			    <PackageReference Include="xunit" Version="2.4.1" />
			    <PackageReference Include="xunit.runner.visualstudio" Version="2.4.5">
			      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
			      <PrivateAssets>all</PrivateAssets>
			    </PackageReference>
			    <PackageReference Include="coverlet.collector" Version="3.1.2">
			      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
			      <PrivateAssets>all</PrivateAssets>
			    </PackageReference>
			  </ItemGroup>
			
			  <ItemGroup>
			    <ProjectReference Include="../../src/«name»/«name».csproj" />
			  </ItemGroup>
			
			</Project>
		''')
	}

	protected def static void generateSrcProjectCsproj(IFileSystemAccess2 fsa, String name) {
		fsa.generateFile('''«name»/src/«name»/«name».csproj''', '''
			<Project Sdk="Microsoft.NET.Sdk">
			
			    <PropertyGroup>
			        <OutputType>Exe</OutputType>
			        <TargetFramework>net6.0</TargetFramework>
			        <ImplicitUsings>enable</ImplicitUsings>
			        <Nullable>enable</Nullable>
			    </PropertyGroup>
				
				<ItemGroup>
					<PackageReference Include="MQTTnet" Version="3.1.2"/>
					<PackageReference Include="MQTTnet.Extensions.ManagedClient" Version="3.1.2"/>
				</ItemGroup>
			</Project>
		''')
	}
}
