# TogoID

## Web API

Note: All your request URLs must be percent-encoded

### ID conversion

#### URL

`GET` /convert?id=249%2C250&from=hgnc

#### Parameters

| Key  | Value  |
|------|--------|
| id `required` | Identifiers (comma or whitespace separated) |
| from | Input data source<br />Detect automatically if no value specified |
| to | Output data source |

Available data sources

| Data source | Value | Pattern | Auto detection |
|:-----------:|:-----:|---------|:--------------:|
| HGNC ID | hgnc | <code>^((HGNC&#124;hgnc):)?\d{1,5}$</code> | △ (if prefix given) |
| NCBI Gene ID | ncbi | `^\d+$` | × |
| RefSeq ID | refseq | <code>^(NC&#124;NG&#124;NM&#124;NR&#124;NT&#124;XM&#124;XR&#124;YP)_\d+$</code> | ○ |
| Affymetrix ID | affymetrix | | ○ |
| Ensembl ID | ensg | `^ENSG\d{11}$` | ○ |

#### Response

Body

```json
[
  {
    "source": {
      "id": "249",
      "type": "hgnc"
    },
    "destination": [
      {
        "id": "124",
        "type": "ncbi_gene"
      }
    ]
  },
  {
    "source": {
      "id": "250",
      "type": "hgnc"
    },
    "destination": [
      {
        "id": "125",
        "type": "ncbi_gene"
      }
    ]
  }
]
```

## Development
