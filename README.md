To use this command line tool, first [obtain a consumer key and access token from Pocket](https://getpocket.com/developer/docs/authentication).

Examples:  
```
ruby pocket.rb --consumer-key CONSUMER-KEY --access-token ACCESS-TOKEN
``` 
  
Output to a file:  
```
ruby pocket.rb --consumer-key CONSUMER-KEY --access-token ACCESS-TOKEN > pocket-articles.txt
```

Format with github markdown syntax:  
```
ruby pocket.rb --consumer-key CONSUMER-KEY --access-token ACCESS-TOKEN --markdown > pocket-articles.txt
```
