import createDynamicFields from "src/decidim/admin/dynamic_fields.component";
const placeholderId = "spam-signal-conditions";
const addConditionItemSelector = ".add-condition-item";
const removeConditionItemChildSelector = ".remove-condition-item-child";
const moveUpConditionItemSelector = ".move-up-condition-item";
const moveDownConditionItemSelector = ".move-down-condition-item";
const conditionItemSelector = ".spam-signal-flow-conditions-child";
const conditionItemsListSelector = ".spam-signal-flow-conditions-items-list";

const toggleDisabledAddConditionItem = () => {
  const maxLength = $(`#${placeholderId}`).data("conditions-max-length");
  const currentLength = $(conditionItemSelector).length;
  if (currentLength >= maxLength) {
    $(addConditionItemSelector).prop("disabled", true);
  } else {
    $(addConditionItemSelector).prop("disabled", false);
  }
};

const autoName = (conditionItemSelector, $field) => {
  $field.find("input").attr("name", `flow[conditions][${$(conditionItemSelector).length}][anti_spam_condition_id]`)    
}

const createDynamicFieldsForConditions = () => {
  createDynamicFields({
    placeholderId: placeholderId,
    wrapperSelector: `#${placeholderId}`,
    containerSelector: conditionItemsListSelector,
    fieldSelector: conditionItemSelector,
    addFieldButtonSelector: addConditionItemSelector,
    removeFieldButtonSelector: removeConditionItemChildSelector,
    onAddField: ($field) => {
      toggleDisabledAddConditionItem();
      autoName(conditionItemSelector, $field);
    },
    onRemoveField: ($field) => {
      $field.remove();
      toggleDisabledAddConditionItem();
    }
  });
  toggleDisabledAddConditionItem()
};

$(function () {
  createDynamicFieldsForConditions();
});
