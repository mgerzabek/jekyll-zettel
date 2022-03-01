## 0.1.0

- Initial Import

## 0.7.x

- Added inline citations

### 0.7.1

- Changed inline citation regex to be compatible with pandoc [@<key>…]
- Emit warning when no reference for given _cite-key_ is found

### 0.7.2

- Objektkatalog aliases.json mit Mapping von Tag Klarnamen und Alternativen wird jetzt generiert
- Log-Level beim Serialisieren der Objektkataloge auf debug gestellt
- Jetzt werden auch Links auf Keywords erkannt und automatisch mit der jeweiligen Glosse verlinkt
- 