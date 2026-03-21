function refreshDisplayIf(element, attachEvents = false) {
  const condition = element.getAttribute("data-display-if");
  const fieldToCheckClass = `.field--antispam.field--${condition} input[type=checkbox]`;
  const fieldToCheck = document.querySelectorAll(fieldToCheckClass);
  if (fieldToCheck.length == 0) {
    throw new Error("Field to check not found");
  }

  if (attachEvents) {
    fieldToCheck[0].addEventListener("change", () => {
      refreshDisplayIf(element);
    });
  }
  const visible = fieldToCheck[0].checked;
  element.classList.toggle("field--antispam-visible", visible);
}

(function () {
  const displayIf = document.querySelectorAll(".js-antispam-display-if");
  displayIf.forEach((element) => {
    refreshDisplayIf(element, true);
  });
})();
