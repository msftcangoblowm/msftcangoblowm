<!--

You can manually process this file with cog:

    $ . .venv/bin/activate
    $ python -m pip install -r requirements.in
    $ python -m cogapp -rP README.md

or

    $ . .venv/bin/activate
    $ python -m pip install -r requirements.in
    $ make view

Will issue warning message and exit if venv not activated

On GitHub, it's generated by an action:

    https://github.com/msftcangoblowm/msftcangoblowm/blob/master/.github/workflows/build.yml

-->

<!-- [[[cog

    import base64
    import datetime
    import os
    import sys
    import time
    from urllib.parse import quote, urlencode

    import requests

    def requests_get_json(url):
        """Get JSON data from a URL, with retries."""
        headers = {}
        token = None
        if "github.com" in url:
            token = os.environ.get("GITHUB_TOKEN", "")
        if token:
            headers["Authorization"] = f"Bearer {token}"

        for _ in range(3):
            sys.stderr.write(f"Fetching {url}\n")
            resp = requests.get(url, headers=headers)
            if resp.status_code == 200:
                break
            print(f"{resp.status_code} from {url}:", file=sys.stderr)
            print(resp.text, file=sys.stderr)
            time.sleep(1)
        else:
            raise Exception(f"Couldn't get data from {url}")
        return resp.json()

    def rounded_nice(n):
        """Make a good human-readable summary of a number: 1734 -> "1.7k"."""
        n = int(n)
        ndigits = len(str(n))
        if ndigits <= 3:
            return str(n)
        elif 3 < ndigits <= 4:
            return f"{round(n/1000, 1):.1f}k"
        elif 4 < ndigits <= 6:
            return f"{round(n/1000):d}k"
        elif 6 < ndigits <= 7:
            return f"{round(n/1_000_000, 1):.1f}M"
        elif 7 < ndigits <= 9:
            return f"{round(n/1_000_000):d}M"

    def shields_url(
        url=None,
        label=None,
        message=None,
        color=None,
        label_color=None,
        logo=None,
        logo_color=None,
    ):
        """Flexible building of a shields.io URL with optional components."""
        params = {"style": "flat"}
        if url is None:
            url = "".join([
                "/badge/",
                quote(label or ""),
                "-",
                quote(message),
                "-",
                color,
                ])
        else:
            if label:
                params["label"] = label
        url = "https://img.shields.io" + url
        if label_color:
            params["labelColor"] = label_color
        if logo:
            params["logo"] = logo
        if logo_color:
            params["logoColor"] = logo_color
        return url + "?" + urlencode(params)

    def md_image(image_url, text, link, title=None, attrs=None):
        """Build the Markdown for an image.

        image_url: the URL for the image.
        text: used for the alt text and the title if title is missing.
        link: the URL destination when clicking on the image.
        title: the title text to use.
        attrs: HTML attributes (switches to HTML syntax)
        """
        if title is None:
            title = text
        assert "]" not in text
        assert '"' not in title
        if attrs:
            img_attrs = " ".join(f'{k}="{v}"' for k, v in attrs.items())
            return f'[<img src="{image_url}" title="{title}" {img_attrs}/>]({link})'
        else:
            return f'[![{text}]({image_url} "{title}")]({link})'

    def badge(text=None, link=None, title=None, **kwargs):
        """Build the Markdown for a shields.io badge."""
        return md_image(image_url=shields_url(**kwargs), text=text, link=link, title=title)

    def badge_mastodon(server, handle):
        """A badge for a Mastodon account."""
        # https://github.com/badges/shields/issues/4492
        # https://docs.joinmastodon.org/methods/accounts/#lookup
        url = f"https://{server}/api/v1/accounts/lookup?acct={handle}"
        followers = requests_get_json(url)["followers_count"]
        return badge(
            label=f"@{handle}", message=rounded_nice(followers),
            logo="mastodon", color="96a3b0", label_color="450657", logo_color="white",
            text=f"Follow @{handle} on Mastodon", link=f"https://{server}/@{handle}",
        )

    def badge_bluesky(handle):
        """A badge for a Bluesky account."""
        url = f"https://public.api.bsky.app/xrpc/app.bsky.actor.getProfile?actor={handle}"
        followers = requests_get_json(url)["followersCount"]
        return badge(
            label=f"Bluesky", message=rounded_nice(followers),
            logo="icloud", label_color="3686f7", color="96a3b0", logo_color="white",
            text=f"Follow {handle} on Bluesky", link=f"https://bsky.app/profile/{handle}",
        )

    def badge_stackoverflow(userid):
        """A badge for a Stackoverflow account."""
        data = requests_get_json(f"https://api.stackexchange.com/2.3/users/{userid}?order=desc&sort=reputation&site=stackoverflow")["items"][0]
        rep_points = rounded_nice(data["reputation"])
        gold = rounded_nice(data["badge_counts"]["gold"])
        silver = rounded_nice(data["badge_counts"]["silver"])
        bronze = rounded_nice(data["badge_counts"]["bronze"])
        sp = "\N{THIN SPACE}"
        return badge(
            logo="stackoverflow", logo_color=None, label_color="333333", color="e6873e",
            message=(
                f"{rep_points} "
                + f"\N{LARGE YELLOW CIRCLE}{sp}{gold} "
                + f"\N{MEDIUM WHITE CIRCLE}{sp}{silver} "
                + f"\N{LARGE BROWN CIRCLE}{sp}{bronze}"
            ),
            text="Stack Overflow reputation", link=data["link"],
        )

    def data_url(image_file):
        """Read an image file and return a self-contained data URL."""
        assert image_file.endswith((".png", ".jpg"))
        with open(image_file, "rb") as imgf:
            b64 = base64.b64encode(imgf.read()).decode("ascii")
        return f"data:image/png;base64,{b64}"

]]] -->
<!-- [[[end]]] -->

<!--
  ##
  ## BADGES
  ##
  -->

<!-- [[[cog

print(badge_mastodon("mastodon.social", "msftcangoblowme"))
print(badge(
    logo="python", logo_color="FFE873", label_color="306998", message="PyPI", color="4B8BBE",
    text="My PyPI packages", link="https://pypi.org/user/msftcangoblowme",
))
]]] -->
[![Follow @msftcangoblowme on Mastodon](https://img.shields.io/badge/%40msftcangoblowme-0-96a3b0?style=flat&labelColor=450657&logo=mastodon&logoColor=white "Follow @msftcangoblowme on Mastodon")](https://mastodon.social/@msftcangoblowme)
[![My PyPI packages](https://img.shields.io/badge/-PyPI-4B8BBE?style=flat&labelColor=306998&logo=python&logoColor=FFE873 "My PyPI packages")](https://pypi.org/user/msftcangoblowme)
<!-- [[[end]]] -->

### 🤔 PRs under review

- [sphobjinv#307 sphobjinv-textconv](https://github.com/bskinn/sphobjinv/pull/307)

### 🌱 Issues awaiting approval

### 👋 Issues

Open and scheduled issues

- [wreck#22 .unlock file non-exact duplicate lines](https://github.com/msftcangoblowm/wreck/issues/22)

### 🔭 foreshadowing contributions

Issue/PR is proposed one at a time. Each issue/PR appears to be atomic, but
may be part of a larger plan; a series of issue/PRs. Guiding packages
along a gradual path towards maturity.

**Package:** kenobi

| Improvements | desc |
| :- | :- |
| add tox support | Three tox config files. Precedes gh workflows |
| static type checking | <br>add mypy to pre-commit<br>add py.typed file<br>To pyproject.toml add classifier<br>create stub file<br>in-code documentation |
| gh workflows | <br>quality -- lint mypy format docs<br>coverage -- send coverage stats to codecov<br>testsuite -- prove support on MacOS, Windows, Linux for each py interpreter<br>release -- upon tag a commit, create a pypi release<br>python nightly -- run nightly tests to detect breakage<br>codeql-analysis -- security and vulnerability reports<br>dependency-review -- monthly report on dependencies to bump |
| README.md badges | <br>Compactly convey package stats and maturity |

### 😄 PRs merged

- [kenobi#6 pre-compile](https://github.com/patx/kenobi/pull/6)
- [kenobi#4 pep518 support 2025-02-07](https://github.com/patx/kenobi/pull/4)
- [logassert#14 pep518 support 2024-01-22](https://github.com/facundobatista/logassert/pull/14)

### 📫 You can find me at

- [programming.dev python](https://programming.dev/c/python)

- Mastodon: [@msftcangoblowme][mastodon].

<!--
  ##
  ## PYPI PACKAGES
  ##
  -->

<!-- [[[cog
    pkgs = [
        # (pypi name, human name, github repo, (mastserver, masthandle)),
        ("pytest-logging-strict", "pytest plugin logging strict", "msftcangoblowm/pytest-logging-strict"),
        ("logging-strict", "Logging strict", "msftcangoblowm/logging-strict"),
        ("drain-swamp", "Drain swamp", "msftcangoblowm/drain-swamp"),
        ("drain-swamp-action", "Drain swamp action", "msftcangoblowm/drain-swamp-action"),
        ("drain-swamp-snippet", "Drain swamp snippet", "msftcangoblowm/drain-swamp-snippet"),
        ("sphinx-external-toc-strict", "Sphinx external TOC strict", "msftcangoblowm/sphinx-external-toc-strict"),
        ("wreck", "Wreck", "msftcangoblowm/wreck"),
    ]

    def write_package(pkg, human, repo, mastinfo=None):
        description = requests_get_json(f"https://api.github.com/repos/{repo}")["description"]
        main_line = f"[**{human}**](https://github.com/{repo}): {description}"
        pypi_badge = badge(
            url=f"/pypi/v/{pkg}?style=flat",
            text="PyPI",
            link=f"https://pypi.org/project/{pkg}",
            title=f"The {pkg} PyPI page",
        )
        github_badge = badge(
            url=f"/github/last-commit/{repo}?logo=github&style=flat",
            text="GitHub last commit",
            link=f"https://github.com/{repo}/commits",
            title=f"Recent {human.lower()} commits",
        )
        pypi_downloads_badge = badge(
            url=f"/pypi/dm/{pkg}?style=flat",
            text="PyPI - Downloads",
            link=f"https://pypistats.org/packages/{pkg}",
            title=f"Download stats for {pkg}",
        )
        print(f"- {main_line}<br/>")
        print(f"  {pypi_badge} {github_badge} {pypi_downloads_badge}")
        if mastinfo is not None:
            print(f"  {badge_mastodon(*mastinfo)}")
]]] -->
<!-- [[[end]]] -->

I maintain a few [**Python packages**][my_pypi], including:

<!-- [[[cog
    for args in pkgs:
        write_package(*args)
]]] -->
- [**pytest plugin logging strict**](https://github.com/msftcangoblowm/pytest-logging-strict): pytest fixture logging configured from packaged YAML<br/>
  [![PyPI](https://img.shields.io/pypi/v/pytest-logging-strict?style=flat?style=flat "The pytest-logging-strict PyPI page")](https://pypi.org/project/pytest-logging-strict) [![GitHub last commit](https://img.shields.io/github/last-commit/msftcangoblowm/pytest-logging-strict?logo=github&style=flat?style=flat "Recent pytest plugin logging strict commits")](https://github.com/msftcangoblowm/pytest-logging-strict/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/pytest-logging-strict?style=flat?style=flat "Download stats for pytest-logging-strict")](https://pypistats.org/packages/pytest-logging-strict)
- [**Logging strict**](https://github.com/msftcangoblowm/logging-strict): logging.config yaml Strict typing and editable<br/>
  [![PyPI](https://img.shields.io/pypi/v/logging-strict?style=flat?style=flat "The logging-strict PyPI page")](https://pypi.org/project/logging-strict) [![GitHub last commit](https://img.shields.io/github/last-commit/msftcangoblowm/logging-strict?logo=github&style=flat?style=flat "Recent logging strict commits")](https://github.com/msftcangoblowm/logging-strict/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/logging-strict?style=flat?style=flat "Download stats for logging-strict")](https://pypistats.org/packages/logging-strict)
- [**Drain swamp**](https://github.com/msftcangoblowm/drain-swamp): Python build-backend with build plugin support<br/>
  [![PyPI](https://img.shields.io/pypi/v/drain-swamp?style=flat?style=flat "The drain-swamp PyPI page")](https://pypi.org/project/drain-swamp) [![GitHub last commit](https://img.shields.io/github/last-commit/msftcangoblowm/drain-swamp?logo=github&style=flat?style=flat "Recent drain swamp commits")](https://github.com/msftcangoblowm/drain-swamp/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/drain-swamp?style=flat?style=flat "Download stats for drain-swamp")](https://pypistats.org/packages/drain-swamp)
- [**Drain swamp action**](https://github.com/msftcangoblowm/drain-swamp-action): Make config settings available to Python build backend<br/>
  [![PyPI](https://img.shields.io/pypi/v/drain-swamp-action?style=flat?style=flat "The drain-swamp-action PyPI page")](https://pypi.org/project/drain-swamp-action) [![GitHub last commit](https://img.shields.io/github/last-commit/msftcangoblowm/drain-swamp-action?logo=github&style=flat?style=flat "Recent drain swamp action commits")](https://github.com/msftcangoblowm/drain-swamp-action/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/drain-swamp-action?style=flat?style=flat "Download stats for drain-swamp-action")](https://pypistats.org/packages/drain-swamp-action)
- [**Drain swamp snippet**](https://github.com/msftcangoblowm/drain-swamp-snippet): Change portions of static config files<br/>
  [![PyPI](https://img.shields.io/pypi/v/drain-swamp-snippet?style=flat?style=flat "The drain-swamp-snippet PyPI page")](https://pypi.org/project/drain-swamp-snippet) [![GitHub last commit](https://img.shields.io/github/last-commit/msftcangoblowm/drain-swamp-snippet?logo=github&style=flat?style=flat "Recent drain swamp snippet commits")](https://github.com/msftcangoblowm/drain-swamp-snippet/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/drain-swamp-snippet?style=flat?style=flat "Download stats for drain-swamp-snippet")](https://pypistats.org/packages/drain-swamp-snippet)
- [**Sphinx external TOC strict**](https://github.com/msftcangoblowm/sphinx-external-toc-strict): A sphinx extension that allows the site-map to be defined in a single YAML file<br/>
  [![PyPI](https://img.shields.io/pypi/v/sphinx-external-toc-strict?style=flat?style=flat "The sphinx-external-toc-strict PyPI page")](https://pypi.org/project/sphinx-external-toc-strict) [![GitHub last commit](https://img.shields.io/github/last-commit/msftcangoblowm/sphinx-external-toc-strict?logo=github&style=flat?style=flat "Recent sphinx external toc strict commits")](https://github.com/msftcangoblowm/sphinx-external-toc-strict/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/sphinx-external-toc-strict?style=flat?style=flat "Download stats for sphinx-external-toc-strict")](https://pypistats.org/packages/sphinx-external-toc-strict)
- [**Wreck**](https://github.com/msftcangoblowm/wreck): Manage and fix requirements files for Python package authors<br/>
  [![PyPI](https://img.shields.io/pypi/v/wreck?style=flat?style=flat "The wreck PyPI page")](https://pypi.org/project/wreck) [![GitHub last commit](https://img.shields.io/github/last-commit/msftcangoblowm/wreck?logo=github&style=flat?style=flat "Recent wreck commits")](https://github.com/msftcangoblowm/wreck/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/wreck?style=flat?style=flat "Download stats for wreck")](https://pypistats.org/packages/wreck)
<!-- [[[end]]] -->

<!--

Package imagery

  -->

### :see_no_evil: Mascots

Most but not all packages have mascots and banners. Imagery is pieced together
from FOSS svg files. Credits and Licenses are meticulously documented,
in their respective packages, for every single asset used.

<!-- [[[cog
mascots = [
    (
        "https://raw.githubusercontent.com/msftcangoblowm/drain-swamp-snippet/refs/heads/master/docs/_static/snip-logo.png",
        "drain-swamp-snippet mascot",
        "https://msftcangoblowm.github.io/drain-swamp-snippet/",
        "Drain swamp snippet mascot",
        {"width": "256px", "height": "279px"},
    ),
    (
        "https://raw.githubusercontent.com/msftcangoblowm/logging-strict/refs/heads/master/docs/_static/logging-strict-logo.svg",
        "logging-strict mascot",
        "https://logging-strict.readthedocs.io/en/stable",
        "Logging strict mascot",
        {"width": "256px", "height": "256px"},
    ),
    (
        "https://raw.githubusercontent.com/msftcangoblowm/sphinx-external-toc-strict/refs/heads/main/docs/_static/sphinx-external-toc-strict-logo.svg",
        "sphinx-external-toc-strict mascot",
        "https://sphinx-external-toc-strict.readthedocs.io/en/stable",
        "Sphinx external TOC strict mascot",
        {"width": "256px", "height": "256px"},
    ),
    (
        "https://raw.githubusercontent.com/msftcangoblowm/wreck/refs/heads/master/docs/_static/wreck-logo-1.svg",
        "wreck mascot",
        "https://wreck.readthedocs.io/en/stable",
        "Wreck mascot",
        {"width": "256px", "height": "256px"},
    ),
    
]
for t_mascot in mascots:
    image_url, text, link, title, attrs = t_mascot
    mascot_image = md_image(image_url, text, link, title=title, attrs=attrs)
    print(f"  {mascot_image}<br>")
]]] -->
[<img src="https://raw.githubusercontent.com/msftcangoblowm/drain-swamp-snippet/refs/heads/master/docs/_static/snip-logo.png" title="Drain swamp snippet mascot" width="256px" height="279px"/>](https://msftcangoblowm.github.io/drain-swamp-snippet/)<br>
[<img src="https://raw.githubusercontent.com/msftcangoblowm/logging-strict/refs/heads/master/docs/_static/logging-strict-logo.svg" title="Logging strict mascot" width="256px" height="256px"/>](https://logging-strict.readthedocs.io/en/stable)<br>
[<img src="https://raw.githubusercontent.com/msftcangoblowm/sphinx-external-toc-strict/refs/heads/main/docs/_static/sphinx-external-toc-strict-logo.svg" title="Sphinx external TOC strict mascot" width="256px" height="256px"/>](https://sphinx-external-toc-strict.readthedocs.io/en/stable)<br>
[<img src="https://raw.githubusercontent.com/msftcangoblowm/wreck/refs/heads/master/docs/_static/wreck-logo-1.svg" title="Wreck mascot" width="256px" height="256px"/>](https://wreck.readthedocs.io/en/stable)<br>
<!-- [[[end]]] -->

<!--
  ##
  ## FOOTER
  ##
  -->

<br/>
<br/>

This is a [Markdown page with embedded Python code][readme.md] rendered with [cog][cog].
See blog post **[Cogged GitHub profile][blog_post]** for details.

<!-- [[[cog
    print(f"*Updated at {datetime.datetime.now():%Y-%m-%d %H:%M} UTC*")
]]] -->
*Updated at 2025-02-18 09:24 UTC*
<!-- [[[end]]] -->

[mastodon]: https://mastodon.social/@msftcangoblowme
[my_pypi]: https://pypi.org/user/msftcangoblowme "The list of all my packages on PyPI"
[cog]: https://github.com/nedbat/cog "The cog repo on GitHub"
[readme.md]: https://github.com/nedbat/nedbat/blob/main/README.md?plain=1 "The raw source for this GitHub profile"
[blog_post]: https://nedbatchelder.com/blog/202409/cogged_github_profile.html "Discussion of how this page is constructed"
