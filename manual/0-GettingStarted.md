# Summary

At the end of completing the procedures outlined in this repository, a fully functional Google Cloud environment will be provisioned with a running and ready to use MultiCloud Private Edition stack. 

# Technologies Used
The following frameworks, services, etc are used throughout the Quickstart deployment scripts:
- Terraform
- Helm
- Shell

# DNS Considerations and Delegation
The Terraform logic in future procedures will setup Google Cloud DNS and create a wildcard A record entry with value of "*.PROVIDED_FQDN" for the MultiCloud applications. As the MultiCloud Services are spun up and if they require external access, then the wildcard entry will be used to provide DNS resolution. 

The expectation is that a domain name is already procured. This can be a newly purchased domain or an root/subdomain off an existing purchased domain...the decision is up to you. 

Cloud DNS within Google Cloud is used natively within the Terraform and Helm logic throughout the provisioning process. Cloud DNS is not a mandatory service though and different DNS providers can be used if desired. If a different DNS provider is used, then the necessary A records will need to be setup. This can be a single wildcard entry (EX: *.fqdn.com where fqdn.com is substituted for your domain) to cover the spectrum of applications that are stood up or a unique A record for each MultiCloud Private Edition web application. If a unique entry for each web application is chosen, then the following URL's and A records needed are as follows:
- gauth.domain.com
