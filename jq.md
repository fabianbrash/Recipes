```jq examples```


````
az aks get-versions | jq '.orchestrators[] | {orchestratorVersion}'

````


[https://lzone.de/cheat-sheet/jq](https://lzone.de/cheat-sheet/jq)


[https://www.baeldung.com/linux/jq-command-json](https://www.baeldung.com/linux/jq-command-json)




````

[
  {
    "name": "apple",
    "color": "green",
    "price": 1.2
  },
  {
    "name": "banana",
    "color": "yellow",
    "price": 0.5
  },
  {
    "name": "kiwi",
    "color": "green",
    "price": 1.25
  }
]

````

##### Get the name from the above

````

jq '.[] | .name' fruits.json

````
