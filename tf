Teams invite - 

https://teams.microsoft.com/l/meetup-join/19%3ameeting_Y2M0YzJjZmUtMTRhMS00Njg5LWJjMTAtZTJjMzlhOWZhOWRj%40thread.v2/0?context=%7b%22Tid%22%3a%22571e8003-4aab-4b85-99e9-7237746f7fca%22%2c%22Oid%22%3a%22f3cb5712-e858-4d26-ad10-aed9a7112285%22%7d

Terraform Training 15th July Terraform
*To access etherpad: https://etherpad.opendev.org/p/-Terraform-tf-july

to access the lms : https://www.infotek.com/course/Terraform-terraform-associate-24th-july-b2

Installation of Terraform:
    1- download terraform https://developer.hashicorp.com/terraform/install
    2- Verify the installation using terraform -v command on cmd
    
    Terraform docs: https://developer.hashicorp.com/terraform/docs
    
Editor to write terraform configurations: https://code.visualstudio.com/download

Login to AWS console: https://ashokbnj.signin.aws.amazon.com/console
      Username and Password (later for own local machine setup use trial account or corporate account for testing)
      
      
Terraform Registry:  https://registry.terraform.io/    4333

Terraform configuration files end with .tf extension.
These configuration files contains blocks of code.

Save logs of powershell terminal on windows: start-transcript / stop-transcript

Start Writing TF configuration in HCL (Hashicorp Configuration Language) made up of blocks

Day1 - Hands-on
 
Terraform Package Installation
Visual Studio Code Editor Installation
Set Environment Variable for Terraform Installed path
Enabling Extension in visual studio Editor for terraform.
Creating directory & Files via editor
Define "Provider" in code file.
Initialize plugins for providers  "terraform init"


*Terraform Providers
provider "aws" {
    }

#terraform init   (download the plugins from terraform registry to local machine)    


Use downloaded plugin:
    #terraform init -plugin-dir C:\Users\Administrator\Desktop\Terraform\Day1\.terraform\providers

#provider.tf
provider "aws" {
}
provider "google" {  
}
provider "oci" {
}
provider "acme" {
}
terraform {
  required_providers {
    acme = {
      source = "myklst/acme"
      version = "0.2.0"
      
    }
     google = {
      source = "hashicorp/google"
      version = "5.34.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.54.0"
    }
  }
}

Provider Version:
    Arguments for Specifying Provider Version constraint
1- ">=5.0"
2- "<=5.0"
3- ">=5.10,<=5.15"
4- "~>5.0"

*Resource Block
resource "resource_type" "reference_name_for_Tf" {
args1 = value1
args2  = value2
}

resource_type= provider_resource_name
reference_name = resource_name

#main.tf
resource "aws_instance" "instance1" {
  ami = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
   tags = {
    Name = "My-vm"
  }
}

#provider.tf
provider "aws" {
 access_key = ""
secret_key = ''"
region = "us-east-1"
}
#terraform plan  (createa aplan based on curretn state and desireed state)

#terraform apply

Task: create S3 bucket
#main.tf
resource "aws_instance" "instance1" {
  ami = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = "My-vm"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "My-9675-Terraform-bucket"
}

#terraform apply -auto-approve
terraform destroy (deletes all resources deployed from current directory)

Day2 - Hands-on
 
Define versions (Representation operators {>=,<=,~=} inside provider block.
Provide Block creation for "AWS"
Resource Block creation for "aws_instance"
Resource Block creation for "aws_s3_bucket"
Terraform Commands
terraform init -upgrade
terraform plan
terraform apply
Terraform apply -auto-approve
terraform destroy
Files


terraform.tfstate   --> It has real time configuration information's
terraform.tfstate.backup --> This is an backup file of very recent ( N-1 ) configuration would be stored .

#terraform destroy -target aws_s3_bucket.name    (deleting specific resource)

Comment to destroy and preserver your configuration.
*single line comments #
*Multi line comments     / *                 *  /

*terraform fmt   (formatting alignment and indentations)
*terraform validate (check for syntax validation)

*Attributes and output
#main.tf
resource "aws_instance" "instance1" {
  ami = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = "My-vm"
  }
}

output "eip-My" {
  value = aws_instance.instance1.public_ip
}

syntax for terraform output

#terraform output <<output reference name>> 
example:
#terraform output    eip-My

*#terraform state list
*#terraform state show resource_type.reference_name

*Variables
variable "var-name" {
    default = ""
    description = ""
    type = ""
    sensitive = ""
    validation = ""
    }

Approach 1: using .tf file for values of varaibles
Example1: in main.tf
#main.tf
resource "aws_instance" "instance1" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = var.ins-name
  }
}

variable "ins-name" {
  default = "test-vm"
}

Example2: in vars.tf
#vars.tf
variable "ins-name" {
  default = "test-vm"
}
#main.tf
resource "aws_instance" "instance1" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = var.ins-name
  }
}

Approach2: taking input from the  user for the values of variables
#vars.tf
variable "ins-name" {
  description = "Enter name for ec2 instance"
}
#main.tf file is same as previous example

#terraform plan -out plan_name
Example #terraform plan -out testplan
#terraform apply testplan
To query use #terraform show planname

Approach3: using .tfvars file
create terraform.tfvars
#terraform.tfvars
ins-name = "Terraform-ins"
s3-name = "Terraform-s3"
eip-name = "Terraform-ip"

#vars.tf
variable "ins-name" {
  default = "default-ins"
}
variable "s3-name" {
  default = "default-s3-buck"
}
variable "eip-name" {
  default = "default-eip"
}

#main.tf
resource "aws_instance" "instance1" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = var.ins-name
  }
}
resource "aws_s3_bucket" "name" {
  bucket = var.s3-name
}
resource "aws_eip" "name" {
  tags = {
    Name = var.eip-name
  }
}

#terraform plan  (variable values will be picked from terraform.tfvars not from vars.tf)
Example2: Create any_name.tfvars
#Terraform.tfvars
ins-name = "Terraform-ins"
s3-name = "Terraform-s3"
eip-name = "Terraform-ip"

#terraform.tfvars is same as above
#main.tf  is same as above
#vars.tf is same as above

#terraform plan(values for variable will be still picked from terraform.tfvars)
#terraform plan -var-file Terraform.tfvars  (here the values will be now taken from Terraform.tfvars)

Example3: create any_name.auto.tfvars
#Terraform.auto.tfvras
ins-name = "Terraform-dev-ins"
s3-name = "Terraform-dev-s3"
eip-name = "Terraform-dev-ip"


#terraform.tfvars is same as above
#main.tf  is same as above
#vars.tf is same as above
#Terraform.tfvars is same as above

#terraform plan (since file is renamed to auto the values will be picked from Terraform.auto.tfvars)
any_name.auto.tfvars>terraform.tfvras>any_name.tf

    
Approach4: using cmd terminal to pass the values of variables
#terraform plan -var ins-name="cmd-instance"

Approach5: Enviroment Variable
set graphically from env setting of the local machine
variable name should start with TF_VAR_variablename
Example: TF_VAR_ins-name, TF_VAR_eip-name, Tf_VAR_s3-name
Note: from cmd set env variable as 
#setx TF_VAR_ins-name new-name

Priority:
    1- cmnd line
    2- auto.tfvars
    3- terraform.tfvars
    4- main.tf or vars.tf
    5- environment variable

*
*Data types:
   Example: string and number
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.s3-names
  count = var.s3-count
}

variable "s3-names" {
  description = "Enter name for S3 bucket"
  type = string
}

variable "s3-count" {
  description = "Enter number of s3 buckets to create"
  type = number
} 

Example: List
Example1:
    #main.tf
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.buck-name[1]
}

variable "buck-name" {
  default = ["buck-dev-9786" , "buck-test-6875687" , "buckt-uat-6785" , "buck-prod-6786"]
  type = list
}

Example2:
#main.tf
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.buck-name[(var.user-inp)-1]
}

variable "buck-name" {
  default = ["buck-dev-9786" , "buck-test-6875687" , "buckt-uat-6785" , "buck-prod-6786"]
  type = list
}
variable "user-inp" {
  description = "Enter the sequence number of the bucket to create s3 from 1-buck-dev--9786 2-buck-test-6875687 3-buckt-uat-6785 4-buck-prod-6786 "
}

Example: Map
#Example1 for Map
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.buck-name.test
}
variable "buck-name" {
  type = map
  #default = {dev = "dev-buck9675" , prod = "prod-buck9675" , test = "testbuck08786" , preprod = "preprodbuck8757"}
  default = {
    dev = "dev-buck9675"
    prod = "prod-buck9675"
    test = "testbuck08786"
    preprod = "preprodbuck8757"
  }
}

Example2:
    #Example1 for Map
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.buck-name[var.user-inp]
}

variable "buck-name" {
  type = map
  #default = {dev = "dev-buck9675" , prod = "prod-buck9675" , test = "testbuck08786" , preprod = "preprodbuck8757"}
  default = {
    dev = "dev-buck9675"
    prod = "prod-buck9675"
    test = "testbuck08786"
    preprod = "preprodbuck8757"
  }
}

variable "user-inp" {
  description = "Enter your working env dev/prod/test/preprod"
}

Validation for variable:
    Example1:
        #main.tf
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.user-inp
}


variable "user-inp" {
  description = "Enter name for s3 bucket"
  validation {
    condition = substr(var.user-inp , 0,3) == "Terraform"
    error_message = "Name should start with Terraform"
  }
}

Example2:
    #main.tf
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.user-inp
}
variable "user-inp" {
  description = "Enter name for s3 bucket"
  validation {
    condition = length(var.user-inp) > 5
    error_message = "Name should be greater then 5 charcters in length"
  }
}

Example3:
    #main.tf
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.user-inp
}
variable "user-inp" {
  description = "Enter name for s3 bucket"
  sensitive = true
  validation {
    condition = length(var.user-inp) > 5 && substr(var.user-inp , 0,3) == "Terraform"
    error_message = "Name should be greater then 5 charcters in length and start with Terraform"
  }
}

*Count and For_each
Count:
two ways to create multiple instance of a resource
using count: works on only list data type
using for_each: works only on map data type
Note: you can not use both together

Example1:
    #main.tf
resource "aws_s3_bucket" "s3bucket" {
  bucket = "bucket-Terraform-day${count.index+1}"
  count = 5
}

Example2:
    #main.tf
    resource "aws_s3_bucket" "s3bucket" {
  bucket = var.s3-names[count.index]
  count = length(var.s3-names)
}

variable "s3-names" {
  default = ["default-buckt-test"]
}

#terraform.tfvars
s3-names = ["clienta-buck" , "clientb-buck" ,"clientc-buck" , "clientd-buck" , "newbukct-newclient"]

For_each:
    #main.tf
    resource "aws_instance" "myname" {
    for_each = var.ins-details
  ami = each.value
  instance_type = "t2.micro"
  tags = {
    Name = each.key
  }
}
variable "ins-details" {
  type = map
  default = {
    dev-instance = "ami-0b72821e2f351e396"
    prod-instance = "ami-01fccab91b456acc2"
    uat-instance = "ami-0a0e5d9c7acc336f1"
  }
}

*Conditinal Expression
Example1:
    #main.tf
    resource "aws_instance" "myname" {
  count         = var.user-inp == "My" ? 1 : 0
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = var.user-inp
  }
}

variable "user-inp" {
  description = "Enter your name"
}

Example2:
    #main.tf
    resource "aws_instance" "myname" {
  count         = var.user-name == "My" ? 1 : 0
  ami           = "ami-0b72821e2f351e396"
  instance_type = var.user-inp == "dev" ? "t2.micro" : "t2.large"
  tags = {
    Name = var.user-inp
  }
}

variable "user-inp" {
  description = "Enter your working environment"
}

variable "user-name" {
  description = "Enter your name"
}

Example3:
    #main.tf
    resource "aws_instance" "myname" {
  count         = contains(var.emp-names , var.user-inp) ? 1 : 0
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.large"
  tags = {
    Name = var.user-inp
  }
}
variable "user-inp" {
  description = "Enter your name"
}
variable "emp-names" {
  default = ["My" , "asim" , "durai" , "rubina" , "vishal"]
}
    

*Functions: https://developer.hashicorp.com/terraform/language/functions
    Note: Lauch terraform console to experiment with the behaviourof the functions
    #terraform console
    #exit
    
    element: used to retreive value from list using index number
    syntax: element(var_list , index_number)
       #main.tf 
        resource "aws_instance" "myname" {
  ami           = "ami-0b72821e2f351e396"
  #instance_type = var.ins-types[5]  #gives error as index is out of range of list
  instance_type = element(var.ins-types ,length(var.ins-types)-1 )
  tags = {
    Name = "My-vm"
  }
}

variable "ins-types" {
  default = ["t2.micro" , "t2.nano" , "t2.large" , "t3.micro" , "t3.large",]
}
        
    lookup: used to retreive value from map using keys
  syntax: lookup (var_map , key , default_value)
  #main.tf
  resource "aws_instance" "myname" {
  ami           = "ami-0b72821e2f351e396"
  #instance_type = var.ins-types[var.user-inp] 
  instance_type = lookup(var.ins-types , var.user-inp , "t3.micro")
  tags = {
    Name = "My-vm"
  }
}

variable "ins-types" {
  default = {
    dev = "t2.micro"
    prod=  "t2.large"
    test = "t2.nano"
  }
}

variable "user-inp" {
  description = "Enter your working env dev/prod/test"
}
  
zipmap: zip two different list of equal length and create a map
syntax: zipmap(list_to_be_key , list_to_be_value)

#main.tf
resource "aws_instance" "myname" {
    count = 5
  ami           = "ami-0b72821e2f351e396"
  #instance_type = var.ins-types[var.user-inp] 
  instance_type = lookup(var.ins-types , var.user-inp , "t3.micro")
  tags = {
    Name = "My-vm${count.index}"
  }
}
variable "ins-types" {
  default = {
    dev = "t2.micro"
    prod=  "t2.large"
    test = "t2.nano"
  }
}
variable "user-inp" {
  description = "Enter your working env dev/prod/test"
}
output "names" {
  value = zipmap(aws_instance.myname[*].id , aws_instance.myname[*].public_ip)
}

Task: create 4 s3 buckets and zip arn and bucket names in output block (weekend task)

Locals: assigning a name to an expression
#main.tf
resource "aws_instance" "name" {
  ami = local.myamiids
  instance_type = local.ins-types
}

locals {
  myamiids = "ami-0b72821e2f351e396"
  ins-types = "t2.micro"
}

    
Csvdecode and file function:
    #main.tf
    resource "aws_instance" "name" {
  ami = local.ins-data[count.index].ami-ids
  instance_type = local.ins-data[count.index].instance-types
  count = length(local.ins-data)
   tags = {
    Name = "My${count.index}"
  }
}

locals {
  ins-data = csvdecode(file("./data.csv"))
}


output "mydata" {
  value = local.ins-data
}

Create a new file in curren t directory as data.csv
#data.csv
ami-ids,instance-types
"ami-0b72821e2f351e396","t2.micro"
"ami-01fccab91b456acc2","t2.nano"
"ami-0a0e5d9c7acc336f1","t2.large"

#terraform apply

*Debugging in Terraform:
Set env variable as TF_LOG with any of five verboity levels: TRACE, DEBUG, INFO, WARN, ERROR
#setx TF_LOG INFO
To store logs in a file
#setx TF_LOG_PATH C:\path\filename
Note:restart editor to reload env changes


Taint a resource(force recreation after tainting)
Note: it will add taint info to the tfstate file
#terraform plan
#terraform apply
#terraform taint aws_instance.name


Replace a resource(force recreation directly)
#terraform plan
#terraform apply
#terraform apply -replace  aws_instance.name

#main.tf
    resource "aws_instance" "name" {
  ami = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = "Myvm"
  }
}
resource "aws_eip" "name" {
  tags = {
    Name = "My-eip"
    env = "testing"
  }
}

*Terraform Graph:
#main.tf
resource "aws_instance" "name" {
    depends_on = [ aws_eip.name, awsaws_s3_bucket.name ]
  ami = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = "Myvm"
  }
}

resource "aws_eip" "name" {
    depends_on = [ aws_s3_bucket.name ]
  tags = {
    Name = "My-eip"
    env = "testing"
  }
}

resource "aws_s3_bucket" "name" {
  depends_on = [ aws_iam_user.name ]
}

resource "aws_iam_user" "name" {
    
  name = "Terraform-My-"
}
Install extension named as graphviz from tintinweb
select grpah file and then Menu-->view-->command pallete-->graphviz(the graph will be displaye)
#terraform graph > graph

#terraform graph -type=plan > plangraph  (this graph will show the order of resource to be created for plan command)

*Data Source:
First creat a vpc on aws consle directly
Example1:
#main.tf
data "aws_vpc" "myvpc" {
  id = "vpc-0090dccf4807daf04"
  
}
resource "aws_subnet" "main" {
  vpc_id     = data.aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "Main"
  }
}

Example2: Create SG in exisiting vpc made outside terraform
#main.tf
resource "aws_security_group" "myname" {
  name = "My-sg"
  vpc_id = data.aws_vpc.myname.id
}

data "aws_vpc" "myname" {
  id = "vpc-04aa120cf07c4f743"
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.myname.id
  cidr_ipv4         = data.aws_vpc.myname.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

 
* provisioners   
Local Exec:
    #main.tf
    resource "aws_instance" "myname" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  tags = {
    Name = "local-exec-vm-My"
  }

provisioner "local-exec" {
  #when = create
  command = "echo ${self.public_ip} > pubip.yaml"
}
}

Destroy time:
    #main.tf
    resource "aws_instance" "myname" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  tags = {
    Name = "local-exec-vm-My"
  }

provisioner "local-exec" {
  when = destroy
  command = "echo ${self.private_ip} > privateip.yaml"
}

}

*Remote-exec Provisioner:
#main.tf
resource "aws_instance" "myname" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  tags = {
    Name = "local-exec-vm-My"
  }
  key_name = "My-Terraform"
  provisioner "remote-exec" {
    inline = [ 
      "sudo apt-get update -y",
      "sudo apt-get install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
     ]
  }
  connection {
    user = "ubuntu"
    private_key = file("./My-Terraform.pem")
    host = self.public_ip
    type = "ssh"
  }
  }

systemctl status nginx

File provisioner:
    create a file data.txt with some content in current folder day7.
    #main.tf
    resource "aws_instance" "myname" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  tags = {
    Name = "file-exec-vm-My"
  }
  key_name = "My-Terraform"


  provisioner "file" {
    source = "./data.txt"
    destination = "/tmp/data.txt"
  }

  connection {
    user = "ubuntu"
    private_key = file("./My-Terraform.pem")
    host = self.public_ip
    type = "ssh"
  }

  }

*Terraform Import:
    Create an ec2 instance from aws console manually
    
    #import.tf
    import {
        to = aws_instance.myname
        id = "xxxx"
        }
        
    #terraform plan -generate-config-out="inst-console.tf"
    This will generate tf file with all the attributes of an exisiting resource
    
    Revview the file if needed do the changes:
        Example: Change insatnce type(save the file)
  #terraform apply       (this wil import and also modify the instance although instance was not made using TF)
*
*Workspace:
  #terraform workspace list
 #terraform workspace show
#terraform workspace new dev
     #terraform workspace new prod
     #terraform workspace select dev
      #terraform workspace delete prod
    #terraform workspace delete -force prod  

#main.tf
resource "aws_instance" "myname" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  tags = {
    Name = "${var.user-inp}-instance"
  }

}

resource "aws_s3_bucket" "myname" {
  bucket = "${var.user-inp}-bucket-day7"
}

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "${var.user-inp}-vpc"
  }
}

variable "user-inp" {
  description = "Enter your name "
}

*Modules
Create a folder 
Modules--->
-->Mod-instance
-->Mod-s3bucket
-->Mod-instance create two files #main.tf and #vars.tf
#main.tf
resource "aws_instance" "instance1" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = var.ins-name
  }
}
#vars.tf
variable "ins-name" {
default = "default-nstance"
}

-->Mod-s3bucket create two files #main.tf and #vars.tf
#main.tf
resource "aws_s3_bucket" "name" {
  bucket = var.s3-name
}
#vars.tf
variable "s3-name" {
  default = "default-bucket-Terraform"
}

Create new folder day8-->main.tf and provider.tf
#main.tf
module "any_name" {
    source = "../Modules/Mod-instance"
    ins-name = "new_name_for_instance"
    }
    
    module "any_new_name" {
        source = "../Modules/Mod-s3bucket"
        s3-name = "new_s3_name"
        }
*
#terraform init
#terraform plan
#terraform apply
    
Module from terraform registry:
    First install git bash https://git-scm.com/download/win
    #main.tf
    module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"
}

*Output from modules:
Note: output can only be fetched if defined under module configiration files

#mod-instance-->main.tf
#main.tf
resource "aws_instance" "instance1" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  tags = {
    Name = var.ins-name
  }
}

output "ip-mod" {
  value = aws_instance.instance1.public_ip
}

Using module #main.tf
#main.tf
module "Mymod" {
  source = "../modules/mod-instance"
  ins-name = "My-instance"
}

output "vmip" {
  value = module.Mymod.ip-mod
}


*Terraform cloud/Team collaboration:
https://www.hashicorp.com/products/terraform/pricing


https://app.terraform.io/session  Terraform cloud sign in page

To learn git and github: https://git-scm.com/doc      https://www.atlassian.com/git


Remote Collaboration :
GIT- tool to manage repo
GIthub- store repo
Step 1- Download git bash and install
https://git-scm.com/download/win
Step 2- sign up or sign with personal account on github.com
Step 3- create a new public repo 
Initial configuration of git
#git config --global user.name "My"
#git config --global user.email "My@gmail.com
#git config --list  (to verify config)
#cd your folder
#git init  ->to initialize 
#git status -> to check status
#git add .   -> to add files in git
#git commit -m "first commit"  -> to commit changes
#git status(it should say nothing to commit)
#git remote add origin https://github.com/ak9675/Terraformrepo
#git push origin master
Terraform cloud: https://app.terraform.io/session













Parking:
    how to query saved plan ?  terraform show plan_name
    how to display * for sensitve true
    # PowerShell script to read sensitive input with masked display

Write-Host "Enter sensitive input:" -NoNewline
$input = Read-Host -AsSecureString
$secureString = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($input)
$maskedInput = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($secureString)
Write-Host "Masked input: $maskedInput"

data "external" "masked_input" {
    program = ["powershell.exe" , "-File" , "${path.module}/input_masked.ps1"]
}

output "masked_input" {
  value = data.external.masked_input.result
}



















    
