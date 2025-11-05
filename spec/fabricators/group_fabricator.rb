# frozen_string_literal: true

# "ICIJ group" used to be Discourse group with a special field indicating it
# was associated with ICIJ. We discontinued using that field but to avoid
# breaking tests we keep this fabricator.
Fabricator(:icij_group, from: :group)