---
layout: page
title: Blog
permalink: /blog/
order: 1
---

<ul class="post-list">
  {% for post in site.posts %}
    <li>
      {% assign date_format = site.minima.date_format | default: "%b %-d, %Y" %}
      <h2>
        <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title | escape }} <span class="post-meta">{{ post.date | date: date_format }}</span></a>
      </h2>
    </li>
  {% endfor %}
</ul>

<div class="rss-subscribe"><a href="{{ "/feed.xml" | relative_url }}">Subscribe via RSS</a></div>
