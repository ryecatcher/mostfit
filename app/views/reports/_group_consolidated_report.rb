=partial :form
%table.report
  %tr.header
    %th
      Group
    %th{:colspan => "3"}
      Loan amount
    %th{:colspan => "4"}
      Payment
    %th{:colspan => "3"}
      Balance outstanding
    %th{:colspan => "3"}
      Balance Overdue
    %th{:colspan => "3"}
      Advance payment
  %tr.header
    %th
    %th
      Applied
    %th
      Sanctioned
    %th
      Disbursed
    %th
      Principal
    %th
      Interest
    %th
      Fee
    %th
      Total
    %th
      Principal
    %th
      Interest
    %th
      Total
    %th
      Principal
    %th
      Interest
    %th
      Total
    %th
      Principal
    %th
      Interest
    %th
      Total
  - center_id, branch_id = nil, nil
  - length = 16
  - org_total = []
  -@groups.sort_by{|group_id, x| @branches[group_id].name}.each do |group_id, centers|
    -if centers.keys.length>0
      -branch_total = []
      %tr.branch
        %td{:colspan => length+1}
          %b
            =@branches[group_id].name
      -centers.sort_by{|center_id, groups| @centers[center_id].name}.each do |center_id, groups|
        -if groups.keys.length>0
          %tr.center
            %td{:colspan => length+1}
              %b
                =@centers[center_id].name
          - center_total = Array.new(length, 0)
          -groups.sort_by{|group_id, group| group[-1]}.each do |group_id, group|
            %tr.group
              %td
                =group[-1]
              -group[0..-2].each_with_index do |g, idx|
                -if idx==6
                  %td
                    = (group[3]+group[4]+group[5]).to_i
                    -center_total[6]+=(group[3]+group[4]+group[5])
                -else
                  %td
                    =g.to_i
                    -center_total[idx]+=g
          %tr.center_total
            %td
              %b==Center total:
              -branch_total.push(center_total)
            -center_total.each do |ele|
              %td
                %b
                  =ele.to_i
      %tr.branch_total
        %td
          %b==Branch total:
        - org_total << branch_total.transpose.collect{|arr| arr.reduce{|s, x| s+=x}}
        - org_total.last.each do |ele|
          %td
            %b
              =ele.to_i
  %tr.org_total
    %td
      %b==Total
    -org_total.find_all{|x| x.length==length}.transpose.collect{|arr| arr.reduce{|s, x| s+=x}}.each do |ele|
      %td
        %b
          =ele.to_i

