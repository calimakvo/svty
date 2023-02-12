# Servantサンプル

### Build

```
$ stack build
```
### Run

```
$ stack exec svty-exe
```

### アクセス

* /users

```
$ curl http://localhost:8080/users
[{"userId":1,"userAge":50,"userFirstName":"Yoshida","userLastName":"Empty"},{"userId":2,"userAge":88,"userFirstName":"Haskell","userLastName":"Banzai"}]
```

* /userage/[int]

```
$ curl http://localhost:8080/userage/88
[{"userId":2,"userAge":88,"userFirstName":"Haskell","userLastName":"Banzai"}]
$ curl http://localhost:8080/userage/29
[]
```

* /userid/[int]

```
$ curl http://localhost:8080/userid/2
{"userId":2,"userAge":88,"userFirstName":"Haskell","userLastName":"Banzai"}
$ curl http://localhost:8080/userid/100
null
```

* /search?username=[string]

```
$ curl http://localhost:8080/search?username=Yoshida
[{"userId":1,"userAge":50,"userFirstName":"Yoshida","userLastName":"Empty"}]
$ curl http://localhost:8080/search?username=Y
[]
$ curl http://localhost:8080/search
[{"userId":1,"userAge":50,"userFirstName":"Yoshida","userLastName":"Empty"},{"userId":2,"userAge":88,"userFirstName":"Haskell","userLastName":"Banzai"}]
```

* /moduser

  * METHOD： POST
  * パラメータ： '{"modId": 1, "modAge": 99, "modFirstName": "Hideki", "modLastName": "Ya"}'

```
$ curl -X POST -d '{"modId":1, "modAge":99, "modFirstName": "Hideki", "modLastName": "Ya"}' -H 'Accept: application/json' -H 'Content-type: application/json' http://localhost:8080/usermod
[{"userId":1,"userAge":99,"userFirstName":"Hideki","userLastName":"Ya"},{"userId":2,"userAge":88,"userFirstName":"Haskell","userLastName":"Banzai"}]
```
