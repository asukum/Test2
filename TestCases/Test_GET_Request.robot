*** Settings ***
Library  RequestsLibrary
Library  urllib.parse


*** Variables ***
${base_url}    https://clarity.dexcom.com
${login_url}   https://uam1.dexcom.com


*** Test Cases ***
Get_Login
      create session  mysession   ${base_url}
      ${response}=   get request  mysession      /users/auth/dexcom_sts

      #  Validating status code of Get request
      ${status_code}=  convert to string    ${response.status_code}
      should be equal   ${status_code}   200

      #  Fetching the Sign In Url from the Response
      ${signInUrl}=  convert to string   ${response.url}

      #  Parsing  the Sign In Url to seperate the Url and Access Token
      ${parsedurl}=  urlparse  ${signInUrl}

      #  Fetching the access token from the parsed url
      ${accessToken}=  convert to string   ${parsedurl.query}

      ${auth}=   create list  codechallenge   Password123
      create session  mysession   ${login_url}   auth=${auth}
      ${response}=   get request  mysession      /identity/login   params=${accessToken}




