pub const ArgParseError = error{
    MissingArgument,
};

pub const UiError = error{
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
