---
layout: tag
permalink: /tag/
---
<ul>
  {% for tag in site.tags %}
  <li>
    <a href="/tag/{{ tag[0] | slugify }}/">{{ tag[0] }}</a>
  </li>
  {% endfor %}
</ul>