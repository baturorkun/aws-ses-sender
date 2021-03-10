#!/bin/bash

# Created on 2019.08.10
# Update on 2019.08.10 23pm
# Aim: Send email with attachment from AWS SES
# Coder : baturorkun@hmail.com / Batur Orkun

## Global vars


shopt -s expand_aliases

# set the default sed behavior to do a replace with bo backup
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias sedCmd="sed -i ''"
else
  alias sedCmd="sed -i "
fi

function usage() {
    echo "Usage: $0 [-h|--help ]
        [-s|--subject <string> subject/title for email ]
        [-f|--from <email> ]
        [-r|--receiver|--receivers <emails> coma seperated emails ]
        [-b|--body <string> ]
        [-a|--attachment <filename> filepath ]
        [--aws-region <string> Change Default AWS Region ]
        [--aws_access_key_id <string> Change AWS Access Key ID ]
        [--aws_secret_access_key <string> Change AWS Secret Access Key ]
        " 1>&2;
    exit 1;
}

function Error() {
    echo "Error: $1"
    exit
}

function checkRequirements() {

    which  aws
    if [ $? -ne 0 ]; then
        Error "AWS Cli tool is installed"
    fi

    which  base64
    if [ $? -ne 0 ]; then
        Error "base64 tool is installed"
    fi
}


function sendMail() {

    if [[ -z ${ATTACHMENT} ]]; then
        ATTACHMENT=$BODY
        FILENAME="Message.txt"
    else
        FILENAME=$(basename "${ATTACHMENT%}")
        ATTACHMENT=`base64 -i $ATTACHMENT`
    fi

    TEMPLATE="ses-email-template.json"

    TMPFILE="/tmp/ses-$(date +%s)"

    cp $TEMPLATE $TMPFILE

    sedCmd -e "s/{SUBJECT}/$SUBJECT/g" $TMPFILE
    sedCmd -e "s/{FROM}/$FROM/g" $TMPFILE
    sedCmd -e "s/{RECVS}/$RECVS/g" $TMPFILE
    sedCmd -e "s/{BODY}/$BODY/g" $TMPFILE
    sedCmd -e "s/{FILENAME}/$FILENAME/g" $TMPFILE
    sedCmd -e "s/{ATTACHMENT}/$ATTACHMENT/g" $TMPFILE

    aws ses send-raw-email --raw-message file://$TMPFILE
}

while :; do
  case $1 in
    -h|-\?|--help)
        usage
        ;;
    -s|--subject)
        SUBJECT=$2
        shift
        ;;
    -f|--from)
        FROM=$2
        shift
        ;;
    -r|--receiver|--receivers)
        RECVS=$2
        shift
        ;;
    -b|--body)
        BODY=`echo "$2" | base64`
        shift
        ;;
    -a|--attachment)
        ATTACHMENT=$2
        shift
        ;;
    --aws-region)
        AWS_DEFAULT_REGION=$2
        shift
        ;;
    --aws_access_key_id)
        AWS_ACCESS_KEY_ID=$2
        shift
        ;;
    --aws_secret_access_key)
        AWS_SECRET_ACCESS_KEY=$2
        shift
        ;;
    *)  # Default case: No more options, so break out of the loop.
        break
  esac

  shift
done


checkRequirements

sendMail
