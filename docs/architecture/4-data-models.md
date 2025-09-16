# 4. Data Models

## Host
* **Purpose**: Represents a single, complete, and buildable machine configuration.
* **Attributes**: `name`, `system`, `modules`, `users`, `diskConfig`.
* **Relationships**: A Host is composed of Modules, has Users, and may use Secrets and a Hardware-Specific Module.

## User
* **Purpose**: Represents a user account and their environment managed by Home Manager.
* **Attributes**: `username`, `homeDirectory`, `shell`, `packages`, `dotfiles`.
* **Relationships**: A User belongs to one or more Hosts and has one Home Manager Configuration.

## Module
* **Purpose**: Represents a self-contained and reusable unit of configuration.
* **Attributes**: `name`, `type` ('Shared' or 'Hardware-Specific'), `path`, `configuration`.
* **Relationships**: A Module can be imported by Hosts and can be composed of other Modules.

---