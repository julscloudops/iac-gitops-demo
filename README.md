This project showcases the implementation of a CI/CD pipeline that builds, tests and deploys a containerized microservice application to AWS (in this case the Google Boutique Microservices Demo App developed for showcasing the use of cloud native technologies). 

All of the infrastructure is deployed to AWS using Terraform and the state is kept in an S3 bucket. 

The pipeline builds, tests and deploys container images to ECR when a new pull request is made to the respective GitHub repository. 

ELK Stack is used for centralized logging, log aggregation and providing data analytics for the app running in our EKS cluster. 

Prometheus is used for showcasing the implementation of proper observability (i.e. monitoring and alerting based on metrics).

This is an on-going personal project and is still a WIP. For more in depth instructions about how to use the demo please head over to this public Notion page: https://julscampa.notion.site/IaC-with-Terraform-Demo-266a1fb53460429f84e41551c598790d
