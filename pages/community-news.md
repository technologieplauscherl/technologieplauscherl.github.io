---
layout: news
title: Community News
permalink: /community-news/
---

{% assign timr=site.time | date: '%Y%m%d' %}
{% for entry in site.community %}
{% assign dayr=entry.date | date: '%Y%m%d'%}
{% if timr <= dayr %}
{% include communitynews.html news=entry %}
{% endif %}
{% endfor %}
