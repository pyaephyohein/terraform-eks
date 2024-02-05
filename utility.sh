#!/bin/bash
usage() {
 echo "Usage: $0 [OPTIONS]"
 echo "Options:"
 echo " -h, --help      Display this help message"
 echo " -i, --install   Selector install Eg. backend,eks"
 echo " -s, --stage     Terraform Stage Eg. plan,apply,destroy"
 echo " Please use -i first and -s second"
 echo " Eg ./install.sh -i eks -s plan"
}

has_argument() {
    [[ ("$1" == *=* && -n ${1#*=}) || ( ! -z "$2" && "$2" != -*)  ]];
}

extract_argument() {
  echo "${2:-${1#*=}}"
}

func_stage() {
   if [[ ("$vstage" = "plan" && "$vinstall" -eq "backend") ]]; then
        terraform init
        terraform plan --var-file=../env.json
   elif [[ ("$vstage" = "apply" && "$vinstall" -eq "backend") ]]; then
        terraform init
        terraform apply --var-file=../env.json --auto-approve
   elif [[ ("$vstage" = "destroy" && "$vinstall" -eq "backend") ]]; then
        terraform init
        terraform destroy --var-file=../env.json --auto-approve
   elif [[ ("$vstage" = "plan" && "$vinstall" -eq "eks") ]]; then
        terraform init --backend-config=./backend.json
        terraform plan --var-file=../env.json
   elif [[ ("$vstage" = "apply" && "$vinstall" -eq "eks") ]]; then
        terraform init --backend-config=./backend.json
        terraform apply --var-file=../env.json --auto-approve
   elif [[ ("$vstage" = "destroy" && "$vinstall" -eq "eks") ]]; then
        terraform init --backend-config=./backend.json
        terraform destroy --var-file=../env.json --auto-approve
   else
        usage
   fi
}

func_install() {
    if [ "$vinstall" = "backend" ]; then
        cd backend
   elif [ "$vinstall" = "eks" ]; then
        cd eks
   else
        usage
   fi
}

# Function to handle options and arguments
handle_options() {
  while [ $# -gt 0 ]; do
    case $1  in
      -h | --help) 
        usage
        exit 0
        ;;
      -s | --stage)
        vstage=$2
        func_stage
        ;;
      -i | --install)
        vinstall=$2
        func_install
        ;;
      *)
        usage
        ;;
    esac 
    shift
  done
}

# Main script execution
handle_options "$@"
