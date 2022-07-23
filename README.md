# Genesys Multicloud CX Private Edition - Quickstart on GCP

The purpose of this repository is to provide pretested sample platform reference architectures for deploying Genesys Multicloud CX Private Edition containers and Helm charts to Google Kubernetes Engine (GKE).  The content provided in this repository can not be used for QA or Production environments as it is not designed to meet typical HA, DR, multi-region or Security requirements.  All content is being provided AS-IS without any SLA, warranty or coverage via Genesys product support.

This project is derived from the following two repositories maintained by Genesys Product:
* [MultiCloud Platform](https://github.com/genesys/multicloud-platform)
* [MultiCloud Services](https://github.com/genesys/multicloud-services)

## Repository Structure

This repository is broken up into two sections:
* Platform - Contains Terraform files to provision a new GCP project with the necessary Google API's and services. 
* Services - Contains the Helm Charts to provision the Private Edition containers. 

<pre>
multicloud-quickstart
|
├── platform
│   ├── terraform
│   │   ├── [terraform_steps]  -  Terraform files that need to be manually invoked before Cloud Build can take over. like "0-remotestate", "1-network", ...
│   |   |   ├── main.tf
│   |   |   ├── [helm_chart].tf - if deploying Helm charts, then the value overrides per chart
│   |   |   └── README.md  -  Details on all inputs that must be modified
|   |   ├── [cloudbuild]  -  All the terraform files that Cloud Build will automatically loop thru and apply
|   |   |   |── [terraform_steps]  -  like "0-remotestate", "1-network", ...
|   │   |   |   ├── main.tf
|   │   |   |   ├── [helm_chart].tf - if deploying Helm charts, then the value overrides per chart
|   │   |   |   └── README.md  -  Details on all inputs that must be modified
│   |   └── README.md  -  Details on all inputs that must be modified
│   ├── tfm
│   │   ├── [terraform_modules]  -  like "0-remotestate", "1-cloudbuild", ...
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   └── README.md  -  Details on all inputs that must be modified
│   |   └── README.md  -  Overview of each module and order of execution
├── services
│   ├── [multicloud_service_helm_chart]  -  like "gauth", "iwd", ...
│   |   ├── XX_chart_product-subsystem
|   |   |   ├── XX_release_product
|   |   |   |   |── override_values.yaml
|   |   |   |   |── pre-release-script.yaml
|   |   |   |   |── post-release-script.yaml
|   |   |   |── chart.ver
|   |   |   |── override_values.yaml
│   └── README.md  -  Overview of each module and order of execution
└── provision-[product].sh - Shell script responsible for executing the Helm Charts for the specific product
└── cloudbuild-services-[product].yaml - Cloud Build file
</pre>

## Related Sites

All service and product documentation can be found at [docs.genesys.com](https://docs.genesys.com)

For installing Genesys products and services, please checkout [Genesys Multicloud Services repository](https://github.com/genesys/multicloud-services)


## License

All content in this repository is released under the [MIT License](LICENSE)
