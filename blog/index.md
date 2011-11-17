---
layout: default
---

{% for post in site.posts %}

  * [{{ post.title }}]({{ post.url }} "{{ post.title }}")

    {% if post.excerpt %}
      *{{ post.excerpt }}*
    {% endif %}

{% endfor %}
