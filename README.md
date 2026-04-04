technologieplauscherl.at ![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
========================

Die Website für das Tech-Meetup in Linz -> [technologieplauscherl.at](https://technologieplauscherl.at)

## Talk via Pull Request

Du darfst dich gerne selbst als Speaker für das nächste Plauscherl auf der Website eintragen. Wir nehmen bis zu 4 Vorträge pro Veranstaltung.

Dazu einfach das aktuellste Plauscherl-File unter /_plauscherl/ nehmen, und Folgendes hinzufügen:

```
- title: <Dein Thema>
  language: <"de" oder "en">
  speakers:
    - name: <Dein Name>
      img: <Link zu einem Bild von dir, ohne "https://">
    - name: <weiterer Speaker>
      img: <Link zu einem Bild von diesem Speaker, ohne "https://">
```
bei einem Vortrag mit mehreren Speakern zu einem Thema, einfach einen weiteren Eintrag unter "speakers" hinzufügen.
Das Bild ist optional und sollte idealerweise quadratisch sein. Dieses kann unter [img/speaker-avatars](./img/speaker-avatars) abgelegt und dann referenziert werden.