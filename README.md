# DTunes Music Application
DTunes is a decentralized music application that allows you to listen to music on multiple devices. 
## Table of Contents

 
1.) [YouTube API Key. ](#youtubekey)      
2.) [Install. ](#install)   
3.) [GUI Interface. ](#GUI)

<a name="youtubekey"></a> 
<a name="install"></a> 
<a name="GUI"></a> 

## Obtain YouTube API Key
## Installation

Clone the respository and save it to your desired location. 
```
git clone https://github.com/xXSlothaiXx/DTunes.git
cd DTunes
```

### Run the Configuration Script

If you don't have Python3 , run the command below
```
apt-get install python3 && pip3 

use sudo if needed.
```

After you clone the repository, run the cofig.py file and follow the https://localhost.run setup and enter your YouTube API Key. 

```
python3 config.py
```

### Localhost SSH Tunnel Setup

When you run the config.py file, it will first give you the option to create a local ssh Tunnel using localhost.run
The promopt will look like this..

![Image of config script working](https://github.com/xXSlothaiXx/DTunes/blob/master/media/github-photos/Screenshot%20from%202020-06-10%2019-07-16.png)

To get your https://localhost.run  url, you'll need to open up another terminal and run this command...

```
ssh -R 80:localhost:8000 ssh.localhost.run
```

After you run that command it should return a URL something like this: https://PCUSERNAME-randomstring.localhost.run/. Copy that url WITHOUT HTTP:// or HTTPS://, YOU ONLY need the DOMAIN. If you don't do this correctly, your port forward will not work correctly. 

Once you've entered your localhost.run url, the prompt will ask for your youtube API KEY. You should have a YouTube API Key if you're are following this guide in order. 

```
Enter your YouTube API KEY:
```

### Run the Installer Script 

```
./install.sh
```
If the installer script worked, it should look like this at the end.... 

![Image of installer script working](https://github.com/xXSlothaiXx/DTunes/blob/master/media/artists/default.jpg)

## Run your server






## Download the APP
