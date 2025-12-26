pub const ArgParseError = error{
    MissingArgument,
};

pub const UiError = error{
    WindowCreationFailed,
    RendererCreationFailed,
};
