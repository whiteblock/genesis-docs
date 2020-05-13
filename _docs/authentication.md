---
title: Authenticating Genesis
tags: []
author: whiteblock
permalink: /authentication
---

For most users, no extra steps are needed for authentication. You will be automatically prompted to login when you use the genesis cli for the first time. When it prompts you, it will attempt to open a page in your browser to complete the login. Simply login using your Genesis credentials in the browser tab, and it will take care of the rest.

## Remote Authentication
Genesis can also be authenticated on a remote machine without the use of a browser. To do so, login to genesis on your local machine (`genesis login`) if you have not done so already. Once logged in, simply run the command `genesis auth print-access-token` to print out your authentication tokens. Then simply add the outputed value from print-access-token to the environment variable `GENESIS_CREDENTIALS` on the remote machine. The genesis cli on the remote machine will then use those credentials. 