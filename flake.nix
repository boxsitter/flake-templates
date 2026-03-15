{
  description = "Personal Nix flake templates for development environments";

  outputs = { self }: {
    templates = {
      python = {
        path = ./templates/python;
        description = "Python development environment with venv and requirements.txt";
      };

      # Add future templates here:
      # java = {
      #   path = ./templates/java;
      #   description = "Java development environment with Gradle";
      # };
      # nodejs = {
      #   path = ./templates/nodejs;
      #   description = "Node.js development environment";
      # };
      # rust = {
      #   path = ./templates/rust;
      #   description = "Rust development environment";
      # };
    };

    defaultTemplate = self.templates.python;
  };
}
