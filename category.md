---
layout: category
permalink: /category/
---
<ul>
  {% for category in site.categories %}
  <li>
    <a href="/category/{{ category[0] | slugify }}/">{{ category[0] }}</a>
  </li>
  {% endfor %}
</ul>