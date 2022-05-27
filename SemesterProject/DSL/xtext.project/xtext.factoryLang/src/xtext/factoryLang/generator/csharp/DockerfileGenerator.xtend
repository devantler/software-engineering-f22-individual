package xtext.factoryLang.generator.csharp

import org.eclipse.xtext.generator.IFileSystemAccess2
import xtext.factoryLang.factoryLang.Model

class DockerfileGenerator {
	
	def static generate(IFileSystemAccess2 fsa, Model model) {
		fsa.generateFile('''«model.name»/Dockerfile''','''
			FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
			WORKDIR /app
			COPY *.sln .
			COPY src/«model.name»/*.csproj ./src/«model.name»/
			COPY test/«model.name».Tests/*.csproj ./test/«model.name».Tests/
			RUN dotnet restore
			
			COPY . .
			RUN dotnet build
			
			FROM build AS testrunner
			WORKDIR /app/test/«model.name».Tests
			CMD ["dotnet", "test", "--logger:trx"]
			
			FROM build AS test
			WORKDIR /app/test/«model.name».Tests
			RUN dotnet test --logger:trx
			
			FROM build AS publish
			WORKDIR /app/src/«model.name»
			RUN dotnet publish -c Release -o out
			
			FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
			WORKDIR /app
			COPY --from=publish /app/src/«model.name»/out ./
			EXPOSE 5000
			ENTRYPOINT ["dotnet", "«model.name».dll"]
		''')
	}
	
}