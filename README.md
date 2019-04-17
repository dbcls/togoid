# TogoID

## Prerequsites

## Installation

```
$ bundle exec rails g docker_compose --env=production
$ docker-compose up -d

$ docker-compose exec app bundle exec thor resource:fetch --dir /data/import hgnc
$ docker-compose exec app bundle exec thor resource:load --dir /data/import hgnc

### resource:fetch affymetrix is not yet implemented
$ docker-compose exec app bundle exec thor resource:load --dir /data/import affymetrix
```

## Web API

Note: All your request URLs must be percent-encoded

### ID conversion

#### Parameters

| Key           | Value                                                             |
|---------------|-------------------------------------------------------------------|
| id `required` | Identifiers (comma or whitespace separated)                       |
| from          | Input data source<br />Detect automatically if no value specified |
| to            | Output data source                                                |

Available data sources

| Data source      | Value      | Pattern                                                                         |
|:----------------:|:----------:|---------------------------------------------------------------------------------|
| HGNC Gene Symbol | hgnc       |                                                                                 |
| NCBI Gene ID     | ncbi       | `^\d+$`                                                                         |
| RefSeq ID        | refseq     | <code>^(NC&#124;NG&#124;NM&#124;NR&#124;NT&#124;XM&#124;XR&#124;YP)_\d+$</code> |
| Affymetrix ID    | affymetrix | `\d{4,}((_[asx])?_at)?`                                                         |
| Ensembl ID       | ensg       | `^ENSG\d{11}$`                                                                  |

#### Example

##### Convert single identifier

###### Request

`GET` /convert?id=ALDH1A1

###### Response

```json
[
  {
    "source": {
      "id": "ALDH1A1",
      "type": "hgnc",
      "label": "HGNC"
    },
    "destination": [
      {
        "id": "216",
        "type": "ncbi",
        "label": "NCBI Gene"
      }
    ]
  }
]
```

##### Convert multiple identifier

###### Request

`GET` /convert?id=216%2C8854

Note: `%2C` is URL encoded string for comma

###### Response

```json
[
  {
    "source": {
      "id": "216",
      "type": "ncbi",
      "label": "NCBI Gene"
    },
    "destination": [
      {
        "id": "ALDH1A1",
        "type": "hgnc",
        "label": "HGNC"
      }
    ]
  },
  {
    "source": {
      "id": "8854",
      "type": "ncbi",
      "label": "NCBI Gene"
    },
    "destination": [
      {
        "id": "ALDH1A2",
        "type": "hgnc",
        "label": "HGNC"
      }
    ]
  }
]
```

## Development
