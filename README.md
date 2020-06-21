# DTunes Music Application
DTunes is a decentralized music application that allows you to listen to music on multiple devices. 

## Installation

Clone the respository and save it to your desired location. 
```
git clone https://github.com/xXSlothaiXx/DTunes.git
cd DTunes
```

### Run the Installer Script 

```
./install.sh
```
If the installer script worked, it should look like this at the end.... 

![Image of installer script working](https://github.com/xXSlothaiXx/DTunes/blob/master/media/github-photos/github1.png)

## Run your server

```
python3 dtunes.py 
```

### Localhost SSH Tunnel Setup

If you want to use the first option when running your server, you will need to set up locahost ssh tunneling.... 

#### Run the Configuration Script

```
python3 config.py
```

When you run the config.py file, it will first give you the option to create a local ssh Tunnel using localhost.run
The promopt will look like this..

![Image of config script working](https://github.com/xXSlothaiXx/DTunes/blob/master/media/github-photos/Screenshot%20from%202020-06-10%2019-07-16.png)

To get your https://localhost.run  url, you'll need to open up another terminal and run this command...

```
ssh -R 80:localhost:8000 ssh.localhost.run
```

After you run that command it should return a URL something like this: https://PCUSERNAME-randomstring.localhost.run/. Copy that url WITHOUT HTTP:// or HTTPS://, YOU ONLY need the DOMAIN. If you don't do this correctly, your port forward will not work correctly. 

## Download the APP