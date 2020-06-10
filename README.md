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
After you clone the repository, run the cofig.py file and follow the localhost.run setup and enter your YouTube API Key. 

```
python3 config.py
```

When you run the config.py file, it will first give you the option to create a local ssh Tunnel using localhost.run
The promopt will look like this..
```
===========================================================================
Open up a terminal and PASTE THIS COMMAND: "ssh -R 80:localhost:8000 ssh.localhost.run"
===========================================================================
When you type this command it should give you a url, COPY the domain
EXAMPLE URL:  https://PCUSERNAME-randomstring.localhost.run/
YOUR URL: PCUSERNAME-randomstring.localhost.run
Make sure you REMOVE THE HTTPS:// and only copy the domain name
the url should be: PCUSERNAME-randomchars.localhost.run
===========================================================================
Enter your localhost.run url:
```
To get your localhost.run url, you'll need to open up another terminal and run this command...

```
ssh -R 80:localhost:8000 ssh.localhost.run
```

After you run that command it should return a URL something like this: https://PCUSERNAME-randomstring.localhost.run/. Copy that url WITHOUT HTTP:// or HTTPS://, YOU ONLY need the DOMAIN. If you don't do this correctly, your port forward will not work correctly. 

Once you've entered your localhost.run url, the prompt will ask for your youtube API KEY. You should have a YouTube API Key if you're are following this guide in order. 

```
Enter your YouTube API KEY:
```

If you've done everthing CORRECTLY, you should be able to run the installer script with no problem. 

```
./install.sh
```







## Download the APP
