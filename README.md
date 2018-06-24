# steeleye

This repo contains terraform specifications to deploy/upgrade/destroy an application on AWS, Details are here 
https://github.com/steeleye/recruitment-ext/blob/master/infra/TEST.md

## Requirements

1. terraform (refer https://www.terraform.io/intro/getting-started/install.html )
2. AWS credentials. 
   Set the AWS credencials as enviornment variable, example given below
   
   $ export AWS_ACCESS_KEY_ID=AKIAIOSFODN97EXAMPLE
   
   $ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
3. Make sure your ssh private and public keys are stored as ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub respectively. 

   
## Basic Structure

All variables are defined in `variables*.tf`.
Output variables are defined in 'output.tf'
EC2 instances are defined in 'instances.tf'
VPC and SUBNET are defined in 'vpc.tf'
Default region is defined inside variables.tf , change it if needed. 

## Basic Usage

1. Clone the github project and cd  to the project folder
   git clone https://github.com/betterltn7/steeleye.git
   cd steeleye
2. Run "terraform init" 
3. Run "terraform plan"
   You can see the changes in the infra here, before making the changes.
3. Run "terraform apply" 
   Applying changes to your AWS infra and deploying the web application. This will take upto 10 mins. 
   At the end of the command output it will output the IP of the Nginx webserver. Example below
   
   ------------------------------------------------------------
   Apply complete! Resources: 2 added, 0 changed, 2 destroyed.

   Outputs:

   ip = 54.201.22.84
   ------------------------------------------------------------

 Now we can try to send http requests to this IP  and verify its serving our GO application. Run following
 
  for i in `seq 1 10`; do curl 54.201.22.84  && echo '';done;
 
 If everything works well you will
 see output like this
 
 
Hi there, I'm served from ip-10-0-102-180!
Hi there, I'm served from ip-10-0-102-90!
Hi there, I'm served from ip-10-0-102-180!
Hi there, I'm served from ip-10-0-102-90!
Hi there, I'm served from ip-10-0-102-180!
Hi there, I'm served from ip-10-0-102-90!
Hi there, I'm served from ip-10-0-102-180!
Hi there, I'm served from ip-10-0-102-90!
Hi there, I'm served from ip-10-0-102-180!
Hi there, I'm served from ip-10-0-102-90!



