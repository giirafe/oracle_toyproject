 var btc = document.getElementById("bitcoin");
 var eth = document.getElementById("ethereum");

 var liveprice = {
    "async" : true,
    "scroosDomain": true,
    "url": "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin%2Cethereum&vs_currencies=usd",

    "method" : "GET",
    "headers" : {}
 }

 $.ajax(liveprice).done(function (response) {
    btc.innerHTML = response.bitcoin.usd;
    eth.innerHTML = response.ethereum.usd;
  });