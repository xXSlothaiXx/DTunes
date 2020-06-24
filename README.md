# DTunes
DTunes is a decentralized  application that allows you to share files and media with connected devices. 

## OS Requirements

To use this server side code, you may need to become familiar with a terminal(Don't be intimidated, it's very straight foward and if something doesn't work, it's my fault... NOT YOURS).

I don't have this fully working for Windows but, if you know how to run a Django Application on windows, you can easily get this setup with some minor troubleshooting. Windows support will come soon. 

#### MAC/LINUX Requirements
If  you're on a MAC/LINUX just search "Terminal" in your Application Finder.

#### Android Requirements
For Android, Download the "Termux" app from the Play Store. 

## Installation

After you have a working terminal, follow the guide down below....

Clone the respository to whatever device you choose(Android/Mac/Linux). Save the repository to your desired location. 
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

## Add your Django IP to the Native App Device List
If your server is running correctly you should see and http address running on your computer/android device terminal.  
Copy the http address(It should look like "http://<IP>:8000" ) Copy that address.   
On the network page of the app, add a nickname for the device and paste in the IP Address.    
Example address: http://10.0.0.23:8000   
MAKE sure you include the http:// and the port 8000    

### Localhost SSH Tunnel Setup

If you want to use the first option when running your server, you will need to set up localhost ssh tunneling.... 

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

## Download the Native Application

#### Android
Coming soon.... DTunes is currently getting approved by the Google Play Store.

#### IPhone
I will not be releasing this for IOS because Apple will make me pay WAY too much money just to keep it on the App Store...... Sorry not sorry IPhone users

#### Desktop/Web
Desktop and Web will be available once google releases Desktop/Web support for the Flutter SDK. The UI for this application will be depending on the development of the Flutter SDK because this Technology depends on light-weight, fast native User Experience. I plan for this to be available on Windows/Mac/Linux and any Desktop OS Platforms.  
