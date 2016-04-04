<snippet>
 <content>

##Personal Vanity Pool
Personal Vanity Pool is a fork of Vanitygen (a command line tool for creating vanity bitcoin addresses), adapted to deploy on multiple computers for a 'personal pool' working to find your vanity address.

If you've got more than one computer and are searching for a vanity address, this software is for you! If you have friends and family willing to search for vanity addresses on your behalf, Personal Vanity Pool is setup to use split-key address generation so you can run the work on untrusted client computers. When the desired vanity address is found by a computer in your pool, the PrivkeyPart is sent back to the host computer and client key generation can be stopped. See instructions on setting up split PublicKey.

####Background on vanity addresses and Vanitygen
Bitcoin addresses are endlessly random, but if you generate millions of addresses you can expect to eventually find strings of text that by chance have a word, for example a name.

Here's an example of a vanity bitcoin address (the user wanted an address with the prefix "1CANZP"): **1CANZP**81g12wtxzMa9Br8bESJHcpFdNbzL

All vanity addresses begin with the number 1, it's annoying but it has to be that way.

Use the tools in this repo to make a cloud/pool of computers, stopping only when one computer finds the desired vanity address. Similar to the online bounty service VanityPool, but in this case you control the host server, which is listening on a REST API for reports from any client currently running your instance of the Vanitygen client.


# Usage Quick(est) Start

####Split-key address generation
Services like VanityPool use an algorithmically-safe method of generating private keys for vanity addresses on computers and networks you don't trust. You can skip this step, _only if_:

- You are certain that the client computers are on a LAN with the host computer and all do not have access to the internet.
- You trust the operating system and any code running on the host and client computers.
- Your router or networking setup is trustworthy.
- You have considered traditional ploys (physical access, people looking at the log output).
- You compiled this software from source yourself.
- You have direct access to the computer's hard drive and the knowledge to securely delete the file `save.txt` after an address is found.

_If you understand the above risks but still want to have the clients generate the full private key, set `USE_SPLIT_KEY` to `False` in `vanity_listen.py` before starting the Flask server. Otherwise we hope you will keep this value as `True` and continue through this Quickstart._


#####Steps to generate your PublicKey

1. Generate your host PrivateKey/PublicKey pair with Vanitygen's keyconv tool using the -G flag. It will output a new address, for example:

```
$ keyconv -G
Pubkey (hex): 049476dddd26bf95215c7c5f6e7b0504aa9129ce8d9285470866816e47651db0c80dbae3a8d2c58a07a6691eeef6d4927b6a2b68814c1d8be112d75d66cd221610
Privkey (hex): 9756A8DF3E2EC5103B0C3F6794892BA9AF9B36567402D8815EBC0EE27227F335
Address: 1J4iorMQZKkG2nTU3xPaHoDmYLy33m2tVJ
Privkey: 5JxwKZDekChpnwk5DoAZQPcHRohDxZBQ6NYq6QUX2xUcvbmxb1Z
```


2. Save the **Privkey** (starts with a 5 in the example above) from the output to be used later. Copy the **Pubkey (hex)** into your `vanity_listen.py` Flask server script. Now is a good time to set the vanity address search pattern in the same file.

3. Modify the `server_url` variable in your `client_win64.bat` and/or `client_mac.sh` scripts in preparation to be sent to your client computers.



####Client computers - Quickstart for Windows 64-bit clients
1. Make sure the host Flask server is running on the host computer and listening for calls from the client computers. Test this by going to the URL in your web browser.
2. Open `client_win64.bat` as an administrator by right-clicking the file and selecting "_Run as administrator_".
3. If your firewall software asks to connect to the internet, allow this process. Make sure to allow the connection for more than just this once, because later if the client finds the address it will also need to communicate the PrivkeyPart.
4. Wait as your client(s) look for an address with the desired vanity search pattern.

##Combining the **PrivkeyPart**
After a client finds an address with your vanity search pattern it'll call your Flask server with the resulting PrivkeyPart.
```
Pattern: 1CANZP
Address: 1CANZP81g12wtxzMa9Br8bESJHcpFdNbzL
PrivkeyPart: 5JGeK7LHP5GURoFKzZQquTnbnNfQswboweaJYpCNzDuKRT63Z1N
```
That's not the real PrivateKey, it's just a piece. To calculate the actual PirvateKey of the vanity address again we use Vanitygen's keyconv tool, but this time using the -c flag to combine the PrivateKey we saved from earlier with the PrivkeyPart returned by the client.

```
$ keyconv -c 5JxwKZDekChpnwk5DoAZQPcHRohDxZBQ6NYq6QUX2xUcvbmxb1Z 5JGeK7LHP5GURoFKzZQquTnbnNfQswboweaJYpCNzDuKRT63Z1N
```
This outputs our vanity address' true PrivateKey and since we used this method we can rest assured that our client who found the address can't possibly have the ability to spend the funds, as they don't know the real private key:
```
Address: 1CANZP81g12wtxzMa9Br8bESJHcpFdNbzL
Privkey: 5KRJ3z6r3pQJxjc8BA8WDoekzaXidMv8KD4MR3d9nJXJBNeNLMP
```


##FAQs for the client


#####Q: What happens if the client software is stopped then started again later? Have I lost all the work I started?

A: No you haven't lost anything! The script is brute-forcing with random seeds. Basically we are rolling dice over and over in hopes of getting a specific sequence of numbers by chance. If you haven't rolled the right sequence, it retries. This happens millions of times per second, but there is no 'progress' to save until the one number we're looking for has been found, at which point we can all stop working on the problem.

#####Q: But when I restart the script it starts at 0% again.
A: Yes but that's not a traditional progress bar, that's just the % chance the solution could have been in the number of addresses you've generated. You can flip a coin as many times as you want but get heads every time. Eventually we hope the sheer number of flips will yield a tails, but there's always the chance it won't ever land tails however unlikely that may seem after hundreds of flips. If the script crashed, closed, your computer restarted, etc. just reopen it to start helping with the search again.

#####Q: Wait, so you're saying I might not even be the one to find the answer?
A: Correct. The idea is to use as many computers as possible to roll these metaphorical dice in order to increase the chance/speed of finding the solution.


##Limitations:

- The client will not be able to know whether or not another client has already found the solution unless it has been restarted (causes no harm to restart manually by closing and reopening the script). A future release will have clients periodically poll the server to see if the search should indeed continue, but for now the best we can do is prevent new people from starting to do the computation. As a workaround, you could restart the script on the client as frequently as you feel you should check to see if another client has found the solution, or simply turn off the client script manually on all devices in your pool after you've finished searching.
- Vanitygen is using the client's CPU and is slow in comparison to the GPU version of the software olcvanitygen. In a future release, Personal Vanity Pool will attempt to choose the most appropriate hardware and vanitygen version.

</content>
</snippet>
