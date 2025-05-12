# Precice Environment Constructor

The **Precice Environment Constructor** is a tool designed to simplify the setup and configuration of the [preCICE](https://precice.org/) environment for simulation coupling. This repository provides scripts and instructions to streamline the installation process, ensuring a smooth experience for users.

## Warning

The source code for **CalculiX 2.20** is included in this repository. This is due to internet access restrictions from the official site and the unavailability of repositories hosting the 2.20 version of **CalculiX**. Please ensure compliance with the licensing terms of **CalculiX** when using or distributing this code.

THe source code of **OpenFOAM v2412** is also included for the same reason of internet access restriction. Please ensure compliance with the licensing terms of **OpenFOAM** when using or distributing this code.

## Features

- Preconfigured setup for **preCICE** and its adapters.
- Support for **OpenFOAM**, **DOLFIN**, and **CalculiX** integration.
- Automated build of adapters for **preCICE**.
- Includes additional tools like **ParaView**, **nano**, and **btop** for enhanced usability.
- YAML-based configuration for constructing custom environments.

## Prerequisites

Before using this tool, ensure you have the following installed:

- **Git**: Version control system.
- **Conda**: Package and environment manager.
- **constructor**: Tool for creating custom conda-based installers.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/thomas7428/Precice-Env-Constructor.git
    cd Precice-Env-Constructor
    ```

2. Run the setup script:
    ```bash
    ./run_precice_installer.sh
    ```

3. Follow the on-screen instructions to complete the installation.

## Create your own construct

To create your own custom construct, follow these steps:

1. Modify the `construct.yaml` file:
    - Open the `construct.yaml` file located in the root directory.
    - Update the `name`, `version`, and `channels` fields as needed.
    - Add or remove dependencies under the `specs` section to customize the environment.
    - Adapt the post and pre install scripts.

2. Build the installer (for example for linux x64 machine):
    ```bash
    ./Constructor/prepare_precice_installer.sh
    ```

3. Distribute the installer:
    - The generated installer will be located in the `Constructor` directory. It will be cut in 90MB files.
    - Share the installer and the `run_precice_installer` with your team or use it for deployment.

For more details on customizing the `construct.yaml` file, refer to the [constructor documentation](https://docs.conda.io/projects/constructor/en/latest/).

## Usage

After installation, you can use the environment to leverage **preCICE** and its integrated tools for simulation coupling. The setup supports various solvers and adapters, enabling seamless workflows for your simulation needs. Simply activate the environment and start using the preconfigured tools to streamline your simulation processes.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description.