---
title: "How to trigger iOS Login Autofill for a local React Project"
slug: "ios-autofill-react"
date: 2023-06-19
summary: "How to trigger the automatic iOS Login Autofill for a locally running React Project."
toc: true
tags:
  - macOS
  - iOS
  - React
  - development
  - frontend
---

I once had to debug a problem for a React project that was a side effect of the automatic iOS login autofill. Triggering the iOS autofill for a locally running React project wasn't quite straightforward, so I wanted to document my findings in this blog post.

## tl;dr

You need an https connection with a valid SSL certificate or it won't work.

How to do this is explained below.

## Intro

Safari on iOS offers autofill for login forms if you have the login information stored in your keychain.

However, autofill is only triggered automatically if you have a secure connection (https) with a valid SSL certificate. Otherwise, autofill is offered, but only if you click on the corresponding input field yourself.

The motto seems to be: We only offer it to you automatically if it is really secure, otherwise you do it consciously on your own responsibility.

{{<alert type="info" headline="Real Device & Simulator" content="It works both with a real iOS device as well as with the simulator available on macOS.">}}

## Save login data on iOS

As already mentioned, the autofill can only be triggered if the login data for the matching URL has been saved. Therefore, I want like to document the creation of this data at the beginning, as we will refer to it in the process.

The procedure is similar for a real device and the simulator:

1. Open the "Settings" app
2. Go to "Passwords"
3. Real: Enter the device password
   Simulator: Enter anything
4. Enable "Autofill Passwords"
5. Add a new entry with the + symbol
6. For "Website" insert the corresponding URL
7. Fill in "User Name" and "Password" according to the user data

## What did not work

Since I can well imagine that some people will come up with similar ideas to mine when reading this post, I have also documented all the variants I tried that did not work, for the sake of completeness. So you don't have to do that anymore!

In the beginning, I tried to see if the autofill would work simply via localhost or the corresponding IP in the network, but that didn't work. I made some assumptions about this below.

### URL restrictions

- A `localhost` address cannot be saved manually via the settings. It can only be saved via the context menu at a new login.
- However, an IP can be entered manually

### Connections without https

#### Customizing the `/etc/hosts` file

- Assumption: An IP is not accepted for the autofill (although you could create the login data manually)
- E.g. from `127.0.0.1 localhost` to `127.0.0.1 thisisafakedomain.com`
- Calling the page (`thisisafakedomain.com:3000`) works fine, but autofill is still not triggered

#### Starting the app on port 80 (http)

- Assumption: A domain with port specification is not accepted for autofill (although you could create the login data manually)
- Background: Port 80 is reserved for http, so you don't need to specify the port anymore. So instead of `thisisafakedomain.com:3000` you can simply call `thisisafakedomain.com`
- It can be started with `sudo PORT=80 npm run serve`
- Calling the page works fine, but autofill is still not triggered

### Hypothesis

Since neither an IP nor the additional specification of a port in a URL can be responsible for this, only the insecure connection (http instead of https) remains after the exclusion procedure due to the lack of an SSL certificate.

## What worked

### Tunneling Services

To avoid going straight back into some configuration cave, I first tried Tunneling Services to test my hypothesis.

#### ngrok

I tested [ngrok](https://ngrok.com/ "ngrok") first. It worked right out of the box and the free tier allows non-commercial use. If you want to use it in a commercial project, you have to use one of the paid tiers.

#### Localtunnel

Now it is clear that a tunneling service works. During a short research I stumbled upon [Localtunnel](https://theboroer.github.io/localtunnel-www/ "Localtunnel"), which also worked right out of the box.

Localtunnel can also be installed on macOS via [Homebrew](https://formulae.brew.sh/formula/localtunnel#default "Homebrew localtunnel").

Just start the React app and start the tunnel with `lt --port 3000` (or whatever port your React app is running on). The terminal will provide a URL that allows you to access the local application from anywhere and still make local changes to the code.

#### How to Tunnel Service

1. Start your app
2. Launch your tunnel service
3. Follow the instructions to create login data and use the corresponding URL provided by your tunnel service
4. Open this URL with Safari (make sure that the URL is also opened with https!)
5. You should be greeted directly by the native iOS autofill context menu on your login page
6. Happy debugging!

### Local SSL certificate

If you do not want to use a tunneling service, a local SSL certificate is another alternative.

{{<alert type="info" headline="Follow along" content="If you want to follow the next steps directly, I've provided a super simple React project on [GitHub](https://github.com/stffffn/ios-autofill-test) with a dummy login form.">}}

#### Create the certificate

You can use [mkcert](https://github.com/FiloSottile/mkcert "GitHub mkcert") to create locally valid certificates. For macOS, it can be installed via [Homebrew](https://formulae.brew.sh/formula/mkcert#default "Homebrew mkcert"), for example.

After the installation we first create a Local Certificate Authority, which creates a root certificate and a key.

```bash
mkcert -install
```

Next, we need to create the necessary certificates for our React project. The best way to do this is to navigate to the root directory of your React project and create a `certificate` folder there, for example with:

```shell
mkdir certificate
mkcert -key-file ./certificate/key.pem -cert-file ./certificate/cert.pem localhost $(ifconfig | grep 'inet ' | grep -Fv 127.0.0.1 | awk 'NR==1{print $2}')
```

This command creates the private key and a certificate valid for `localhost` and the IP of your device on the local network.

Now we need to add a script to the `package.json` file to be able to start the app with https and the corresponding certificate as well:

```json
"start:https": "HTTPS=true SSL_CRT_FILE=./certificate/cert.pem SSL_KEY_FILE=./certificate/key.pem npm run start"
```

#### Install the root certificate on iOS

Now we just need to tell iOS to trust our Local Certificate Authority.

In this case, I will limit myself to the macOS simulator. The installation on a real device is identical, only the way how you get the root certificate on your device is a bit different and up to you (Airdrop, Email, NAS, etc.).

If you don't remember where the root certificate was created, you can find it out with this command:

```shell
mkcert -CAROOT
```

Under macOS it is most likely located under `/Users/<YourUsername>/Library/Application Support/mkcert` and is named `rootCA.pem`.

Unfortunately, with the latest restrictions on macOS, it is no longer possible to drag and drop certificates onto the simulator. However, we can still install it relatively easily via the path. If your root certificate is located under the same path, you can copy the following link and paste it into Safari (don't forget to change the username!): `file:///Users/<YourUsername>/Library/Application%20Support/mkcert/rootCA.pem`

You will see a dialog asking you, if you want to allow the download of a configuration file. Click "Allow". After that, You will then see a message indicating that the profile has been downloaded.

Then open the "Settings" app, navigate to "General" and then to "Device Management. The certificate will already be listed there. Click on it and install it.

That's all we needed to do on iOS.

#### Start the React app

Now we start the React app with the `npm run start:https` script we created earlier.

Then we take our iOS device or the simulator, open the "Settings" app, navigate to "Passwords" and add an entry for the corresponding IP. Don't forget to add "https://" and the port at the end. If you are using my GitHub project as a test, just enter anything for the username and password.

Now we can open the website directly from the password details page and should be greeted by the automatically triggered iOS autofill. Done!

Here is a short demo video:

{{<video src="/images/autofill/autofill.mp4" type="video/mp4">}}
