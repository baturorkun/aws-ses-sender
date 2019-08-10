"sender.sh" script can send an email with attachment by using Amazon SES services (Amazon Simple E-mail Services). It needs the AWS Cli tool.

### Install

You have to just install the AWS CLI tool.
There are many ways to install the Amazon Web Service Command Line Client (aka AWS Cli) including using pip package manager, homebrew package manager or just downloading the raw executables.(http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
As a Mac user, I prefer to use Homebrew ( https://brew.sh/ )

```
brew install awscli
```
or 
```
pip3 install --upgrade --user awscli
```

After installing AWS Cli, you must configure the credential file. You can use this command:

```
aws configure
```
### Usage

You can get help with -h or --help argument.

```
$ sh sender.sh -h

Usage: sender.sh [-h|--help ]
        [-s|--subject <string> subject/title for email ]
        [-f|--from <email> ]
        [-r|--receiver|--receivers <emails> coma seperated emails ]
        [-b|--body <string> ]
        [-a|--attachment <filename> filepath ]
        [--aws-region <string> Change Default AWS Region ]
        [--aws_access_key_id <string> Change AWS Access Key ID ]
        [--aws_secret_access_key <string> Change AWS Secret Access Key ]
```

######Examples

```
sh sender.sh -s test -f cem@domain.com -r batur@domain.com -b "mail content" -a ~/Documents/Projects/batur/test.html 
```

```
sh sender.sh -s test -f cem@domain.com -r batur@domain.com -b "mail content" -a ~/Documents/Projects/batur/test.html --aws-region us-east-1
```
