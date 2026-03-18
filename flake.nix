{
  description = "Personal Nix flake templates for development environments";

  outputs = { self }: {
    templates = {
      python = {
        path = ./templates/python;
        description = "Python development environment with venv and requirements.txt";
      };

      nodejs = {
        path = ./templates/nodejs;
        description = "Node.js development environment with npm and package.json";
      };

      # Add future templates here:
      # java = {
      #   path = ./templates/java;
      #   description = "Java development environment with Gradle";
      # };
      # rust = {
      #   path = ./templates/rust;
      #   description = "Rust development environment";
      # };
    };

    defaultTemplate = self.templates.python;
  };
}
