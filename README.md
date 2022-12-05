# Cluster spark, hadoop integrated with jupyter lab and devops in software delivery cycle
Implementation of an architecture for a distributed data processing cluster, integrating Devops into a continuous software delivery stream; through an automated deployment of big data processing infrastructure as code in the cloud.
## Archtecture
![image](https://user-images.githubusercontent.com/72947118/205747955-eca97c3f-7fb1-4194-808f-55673e1e187c.png)

## Student interaction with architecture
![image](https://user-images.githubusercontent.com/72947118/205748115-cd9dacc2-11e3-417d-9a88-75b100556d1c.png)

## Usage

Please ensure you read documentation for [Terraform](https://terraform.io/docs/) and its well written [command-line interface (CLI)](https://terraform.io/docs/commands/index.html) documentation for usage.

The [terraform.tfvars](https://www.terraform.io/intro/getting-started/variables.html) in the [examples](examples/terraform.tfvars) folder is used as a variable overlay and, as per the Terraform documentation, is processed last; meaning, it overrides all command line and environment variables.  

Ensure you modify the URL on line 25 and 29 in [Installs_Cluster.tf](Installs_Cluster.tf) to reflect the correct address of your custom Spark y hadoop distribution.

It's recommended TF_VAR environment and command line variables be used as per the Terraform [documentation](https://www.terraform.io/docs/configuration/variables.html).
## Download
to use the environment modify the file download this project and modify the file [vars.tf](vars.tf), with the required Aws,git and sonarcloud variables.

For each machine cluster, we create the following objects:

* Virtual Private Cloud (VPC), 
* network security groups, 
* network subnets and routing tables, gateways etc.
* machine instances corresponding to 3 nodes within the cluster. 
* In the node master config GitHub Actions, SonarCloud,Jupyter Lab

The VPC, network security groups, network subnets and routing tables ensure all cluster resources are isolated from other managed clusters.


