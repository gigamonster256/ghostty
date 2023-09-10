const std = @import("std");
const Config = @import("Config.zig");

/// Key is an enum of all the available configuration keys. This is used
/// when paired with diff to determine what fields have changed in a config,
/// amongst other things.
pub const Key = key: {
    const field_infos = std.meta.fields(Config);
    var enumFields: [field_infos.len]std.builtin.Type.EnumField = undefined;
    var i: usize = 0;
    inline for (field_infos) |field| {
        // Ignore fields starting with "_" since they're internal and
        // not copied ever.
        if (field.name[0] == '_') continue;

        enumFields[i] = .{
            .name = field.name,
            .value = i,
        };
        i += 1;
    }

    var decls = [_]std.builtin.Type.Declaration{};
    break :key @Type(.{
        .Enum = .{
            .tag_type = std.math.IntFittingRange(0, field_infos.len - 1),
            .fields = enumFields[0..i],
            .decls = &decls,
            .is_exhaustive = true,
        },
    });
};
