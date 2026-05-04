(function() {
  const html = document.querySelector("html");

  function setCookie(name, value, days) {
    let expires = "";
    if (days) {
      var date = new Date();
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
  }

  function getCookie(name) {
    let start = name + "=";
    let cookies = document.cookie.split(';');
    for (let pos = 0; pos < cookies.length; pos++) {
      let cookie = cookies[pos].trim();
      if (cookie.startsWith(start)) {
        return cookie.substring(start.length, cookie.length);
      }
    }
    return null;
  }

  function setDisplay(lang, value) {
    html.querySelectorAll("." + lang).forEach(item => {
      item.style.display = value;
    });
  }

  function toggle(lang, event) {
    const input = html.querySelector("#show" + lang);

    let cookie = getCookie("boxes");

    console.log(cookie);

    let jchecked = cookie == null || cookie.indexOf("java") >= 0;
    let nchecked = cookie == null || cookie.indexOf("net") >= 0;

    if (lang == "java") {
      jchecked = input.checked;
    } else {
      nchecked = input.checked;
    }

    cookie = "";
    if (jchecked) {
      if (nchecked) {
        cookie = "java net";
      } else {
        cookie = "java";
      }
    } else {
      if (nchecked) {
        cookie = "net";
      }
    }

    setCookie("boxes", cookie, 14);

    if (input.checked) {
      setDisplay(lang, "block");
    } else {
      setDisplay(lang, "none");
    }
  }

  const cookie = getCookie("boxes");
  const jchecked = cookie == null || cookie.indexOf("java") >= 0;
  const nchecked = cookie == null || cookie.indexOf("net") >= 0;

  if (!jchecked) {
    setDisplay("java", "none");
  }

  if (!nchecked) {
    setDisplay("net", "none");
  }

  html.querySelectorAll("nav.top .boxes").forEach(span => {
    const java = document.createElement("input");
    java.setAttribute("id", "showjava");
    java.setAttribute("type", "checkbox");
    if (jchecked) {
      java.setAttribute("checked", "checked");
    }

    const jpng = document.createElement("img");
    jpng.setAttribute("src", "/img/java.png");
    jpng.setAttribute("alt", "Java");

    span.appendChild(java);
    span.appendChild(jpng);

    java.onclick = function(event) {
      toggle("java", event);
    }

    const dotnet = document.createElement("input");
    dotnet.setAttribute("id", "shownet");
    dotnet.setAttribute("type", "checkbox");
    if (nchecked) {
      dotnet.setAttribute("checked", "checked");
    }

    const npng = document.createElement("img");
    npng.setAttribute("src", "/img/dotNET.png");
    npng.setAttribute("alt", "Java");

    span.appendChild(dotnet);
    span.appendChild(npng);

    dotnet.onclick = function(event) {
      toggle("net", event);
    }
  });
})();
