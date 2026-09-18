pub const ArgParseError = error{
    MissingArgument,
};

pub const UiError = error{
    SdlInitFailed,
    WindowCreationFailed,
    RendererCreationFailed,
    SurfaceCreationFailed,
    TextureCreationFailed,
    UpdateTextureFailed,
    FillRectFailed,
    RenderCopyFailed,
    RenderDrawColorFailed,
    RenderClearFailed,
};
