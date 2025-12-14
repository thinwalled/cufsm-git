function template_picker_cb(src,~,fig)

    id = get(src,'Tag');        % 'lippedc', 'chs', etc
    if isempty(id), id = ''; end

    setappdata(fig,'TemplateID',id);
    uiresume(fig);

end