<snippet>
 <content>

##Personal Vanity Pool
PersonalVanityPool is a fork of Vanitygen (a command line tool for creating vanity bitcoin addresses), adapted to deploy on multiple computers for a 'personal pool' working to find your vanity address.

If you've got more than one computer and are searching for a vanity address, this software is for you! If you have friends and family willing to search for vanity addresses on your behalf, Personal Vanity Pool is setup to use split-key address generation so you can run the work on untrusted client computers. When the desired vanity address is found by a computer in your pool, the PrivkeyPart is sent back to the host computer and client key generation can be stopped. See instructions on setting up split publickey.

The Vanitygen software uses the host computer's GPU to make millions of random bitcoin addresses, discarding the vast majority until ones with a predetermined pattern are found. Running the script begins a process on as many threads as there are on the CPU (this can be lowered to 1 thread). Eventually, you'll stumble upon an address that has a pattern to it, like 1LOVEYOU or other seemingly non-random but are actually valid 'random' strings of text.

Finding and address with a "1" in it is easy. Finding "1A" is also simple, you might get a pattern with that in just a few hundred generations of bitcoin addresses, at which point you could stop. Due to math, the computational power required to find an address more than 8 or 9 characters long becomes unbearable.

Use the tools in this repo to make a cloud/pool of computers, stopping only when one computer finds the desired vanity address. A flask server is run on the administrators computer, listening on a REST API for reports from any currently running the Vanitygen client.


## Usage
####Host computer - Quickstart for Mac and Windows with Python

Step 1: As the admin/host computer you'll need to make sure a server is running so you can respond to web requests from the client software. Flask is a good choice, you'll need python to run the script. It is highly

Step 2: Choose your vanity address to search for!

Setup your client config, choose your vanity address in the. Remember addresses must start with 1, and it doesn't make sense to try making a vanity address with too many characters. Don't be rude and make a bunch of friends and family search day and night for an address that can't be found for hundreds of years, so go figure out vanitygen
I use 64bit because it's quite a bit faster. Change this according to the rate of your client's CPU.
TODO: Add a dedicated config file

Step 3: TODO

####Client computers - Quickstart for Windows 64-bit clients
######Prerequisites:
1. Make sure the host Flask server is running and listening for calls from the client computer. Test this by going to the URL in your web browser.
2.
3. Download the repository, open

####Split-key address generation
Services like VanityPool use an algorithmically-safe method of generating private keys for vanity addresses. You can skip this step, only if:

1. You are certain that the client computers are on a LAN with the host computer and all do not have access to the internet.
2. You trust the operating system and any code running on the host and client computers.
3. Your router or networking setup is trustworthy.
4. You have considered traditional ploys (physical access, people looking at the log output).
5. You compiled this software from source yourself.

``


##FAQs for the client



Q: What happens if I stop the script and start it again? Have I lost all the work I started?
A: No you haven't lost anything! The script is brute forcing with random seeds. Basically we are rolling dice over and over in hopes of getting a specific sequence of numbers by chance. If you haven't rolled the right sequence, it retries. This happens millions of times per second, but there is no 'progress' to save until the one number we're looking for has been found, at which point we can all stop working on the problem.

Q: But when I restart the script it starts at 0% again.
A: Yes but that's not a traditional progress bar, that's just the % chance the solution could have been in the number of addresses you've generated. You can flip a coin as many times as you want but get heads every time. Eventually we hope the sheer number of flips will yield a tails, but there's always the chance it won't ever land tails however unlikely that may seem after hundreds of flips.

Q: Wait, so you're saying I might not even be the one to find the answer?
A: Correct. The idea is to use as many computers as possible to roll these metaphorical dice in order to increase the chance/speed of finding the solution.

Q: What happ

Q: Which operating systems can I run the PersonalVanityPool

##FAQs for the server



Limitations: Since this software was meant to be used on a lan or with trusted friends,  I have the ability to tell my client computers when to stop trying to find a solution because another client has found it. The client will not be able to know whether or not another client has already found the solution unless it has been restarted (causes no harm to restart manually by closing and reopening the script). I am working on a way to have the clients poll the server, but for now the best we can do is prevent new people from starting to do the computation. As a workaround, you could restart the script on the client somehow as a frequently as you feel you should check to see if another client has found the solution.

</content>
</snippet>
