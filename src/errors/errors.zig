pub const ArgParseError = error{
    MissingArgument,
};

pub const UiError = error{
    SdlInitFailed,
    WindowCreationFailed,
    RendererCreationFailed,
    TextureCreationFailed,
    UpdateTextureFailed,
    FillRectFailed,
    RendererCopyFailed,
    RendererDrawColorFailed,
    RendererClearFailed,
};
